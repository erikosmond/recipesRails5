module TagsService
  def all_tags_with_heirarchy
    tag = Tag.first
    all_tags = true
    tag.tag_with_heirarchy(all_tags)
  end

  def all_family_tags_with_heirarchy
    all_tags_with_heirarchy.where(tag_type: TagType.family_id)
  end

  def grandparent_tags_with_grouped_children(heirarchy)
    all_families = []
    current_family, current_type, current_ingredient = nil, nil, nil
    heirarchy.each do |result|
      if current_family&.id != result.tag_id
        ing_family = Tag.new(name: result.tag_name, id: result.tag_id, tag_type_id: TagType.family_id)
        current_family = ing_family
        all_families << current_family
      end
      if current_type&.id != result.child_tag_id
        ing_type = ChildTag.new(name: result.child_tag_name, id: result.child_tag_id, tag_type_id: TagType.type_id)
        current_family.child_tags << ing_type
        current_type = ing_type
      end
      next if current_ingredient&.id == result.grandchild_tag_id

      ingredient = ChildTag.new(name: result.grandchild_tag_name, id: result.grandchild_tag_id, tag_type_id: TagType.ingredient_id)
      current_type.child_tags << ingredient
      current_ingredient = ingredient
    end
    all_families
    # then also manage the non ingredient types (priority, rating, etc.)
  end

  def group_grandparent_heirarchy_by_id(model_groups)
    model_groups.each_with_object({}) do |family, family_hash|
      family_hash[family.id.to_s] = family.child_tags.each_with_object({}) do |type, type_hash|
        type_hash[type.id.to_s] = type.child_tags.map(&:id).map(&:to_s).compact if type&.id
      end
    end
  end

  def ingredient_group_heirarchy_filters
    heirarchy = all_family_tags_with_heirarchy
    groups = grandparent_tags_with_grouped_children(heirarchy)
    group_grandparent_heirarchy_by_id(groups)
  end
end
