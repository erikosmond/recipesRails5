class PagesController < ApplicationController
  def home
    tag = Tag.find_by_name('On Deck') || Tag.first
    @home_tag_id = tag.id
  end
end
