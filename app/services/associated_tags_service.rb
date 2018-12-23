# frozen_string_literal: true

module AssociatedTagsService
  def tag_with_heirarchy_grouped
    tag_json = as_json(only: %i[id name description tag_type_id recipe_id])
    tag_groups.each do |tg|
      tag_json["#{tg}s"] = {}
    end
    tag_with_heirarchy.each do |t|
      tag_groups.each do |g|
        group_tags(tag_json, t, g)
      end
    end
    tag_json
  end

  def tag_with_heirarchy
    Tag.select(
      tag_heirarchy_select
    ).left_outer_joins(
      tag_heirarchy_join
    ).where("tags.id = #{id}")
  end

  private

    def group_tags(tags_json, tags, group)
      return unless tags["#{group}_id"] && tags["#{group}_name"]

      tags_json["#{group}s"][tags["#{group}_id"]] = tags["#{group}_name"]
    end

    def tag_groups
      groups = %i[
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
      selects = tag_heirarchy_select_children + tag_heirarchy_select_parents + [
        'modifications_tag_selections.id modification_tag_id',
        'modifications_tag_selections.name modification_tag_name'
      ]
      selects << tag_heirarchy_select_modified if modification_tag?
      selects
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
        'child_tags_child_tags.id grandchild_tag_id',
        'child_tags_child_tags.name grandchild_tag_name'
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
        child_tags: :child_tags,
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
