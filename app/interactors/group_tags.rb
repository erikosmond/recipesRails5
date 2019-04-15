class GroupTags
  include Interactor

  def call
    json_fields = %i[id name description tag_type_id recipe_id]
    tag_json = context.tag.as_json(only: json_fields)
    context.tags_with_hierarchy.each do |t|
      tag_groups.each do |g|
        tag_json["#{g}s"] ||= {}
        group_tags(tag_json, t, g)
      end
    end
    context.json = tag_json
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
      groups << :grandchild_tag if context.tag.tag_type_id != TagType.type_id
      groups
    end
end
