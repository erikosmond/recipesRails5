# frozen_string_literal: true

module AssociatedTagsService
  def tag_with_heirarchy_grouped(current_user, all_tags = false)
    tag_json = as_json(only: %i[id name description tag_type_id recipe_id])
    tag_groups.each do |tg|
      tag_json["#{tg}s"] = {}
    end
    tag_with_heirarchy(current_user, all_tags).each do |t|
      tag_groups.each do |g|
        group_tags(tag_json, t, g)
      end
    end
    tag_json
  end

  def tag_with_heirarchy(current_user, all_tags = false)
    heirarchy = Tag.select(
      tag_heirarchy_select
    ).left_outer_joins(
      tag_heirarchy_join
    ).where(
      "accesses.user_id = #{current_user&.id} OR accesses.status = 'PUBLIC'"
    ).order('tags.id, child_tags.id, child_tags_tags.id')
    return heirarchy if all_tags

    heirarchy.where(tags: { id: id })
  end

  private

    def group_tags(tags_json, tags, group)
      return unless tags["#{group}_id"] && tags["#{group}_name"]

      tags_json["#{group}s"][tags["#{group}_id"]] = tags["#{group}_name"]
    end

    def tag_groups
      groups = %i[
        tag
        child_tag
        parent_tag
        grandparent_tag
        modification_tag
        modified_tag
      ]
      groups << :grandchild_tag unless tag_type.name == 'IngredientType'
      groups
    end

    def tag_heirarchy_select
      cols = tag_heirarchy_select_children + tag_heirarchy_select_parents +
             ['tags.id tag_id', 'tags.name tag_name', 'tag_types.id tag_type_id'] +
             [
               'modifications_tag_selections.id modification_tag_id',
               'modifications_tag_selections.name modification_tag_name'
             ]
      cols << tag_heirarchy_select_modified if modification_tag?
      cols
    end

    def tag_heirarchy_select_modified
      [
        'modified_tags_tags.id modified_tag_id',
        'modified_tags_tags.name modified_tag_name'
      ]
    end

    def tag_heirarchy_select_children
      [
        'child_tags.id child_tag_id',
        'child_tags.name child_tag_name',
        'child_tags_tags.id grandchild_tag_id',
        'child_tags_tags.name grandchild_tag_name'
      ]
    end

    def tag_heirarchy_select_parents
      [
        'parent_tags_tags.id parent_tag_id',
        'parent_tags_tags.name parent_tag_name',
        'parent_tags_tags_2.id grandparent_tag_id',
        'parent_tags_tags_2.name grandparent_tag_name'
      ]
    end

    def tag_heirarchy_join
      join_tables = [
        :tag_type,
        child_tag_selections: [:access, { tag: :child_tags }],
        parent_tags: :parent_tags,
        tag_selections: :modifications
      ]
      join_tables << :modified_tags if modification_tag?
      join_tables
    end

    def modification_tag?
      tag_type_name == 'IngredientModification'
    end
end
