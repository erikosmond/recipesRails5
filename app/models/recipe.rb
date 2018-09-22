class Recipe < ApplicationRecord
  has_many :tag_selections,
           as: :taggable,
           dependent: :destroy,
           inverse_of: :taggable
  has_many :tags, through: :tag_selections, source: :tag, inverse_of: :recipes

  has_one :access, as: :accessible

  has_one :ingredient, class_name: 'Tag'

  validates :name, presence: true
  validates :instructions, presence: true

  def ingredients
    props('Ingredient')
  end

  def ingredients_with_detail
    props_with_detail('Ingredient')
  end

  def sources
    props('Source')
  end

  def vessels
    props('Vessel')
  end

  private

    def props_with_detail(name)
      tag_selections.left_outer_joins([:tag_attributes, tag: [:tag_type]]).
        where("tag_types.name = '#{name}'")
    end

    def props(name)
      tags.joins(:tag_type).where("tag_types.name = '#{name}'")
    end
end
