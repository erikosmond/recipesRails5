class PagesController < ApplicationController
  def home
    starting_tag = Tag.find_by_name('On Deck') || Tag.first
    all_tags = Tag.all.each_with_object({}) { |t, obj| obj[t.id] = t.name }
    @home_tag_id = starting_tag.id
    @all_tags = all_tags.to_json
    @tag_groups = Tag.ingredient_group_heirarchy_filters.to_json
  end
end
