# frozen_string_literal: true

class Tag < ApplicationRecord
  include AssociatedRecipesService

  belongs_to :tag_type
  belongs_to :recipe, optional: true, inverse_of: :ingredient
  has_many :tag_attributes, # i.e. Brand, Year
           -> { where(tag_attributable_type: 'Tag') },
           as: :tag_attributable,
           dependent: :destroy

  has_many :tag_selections,
           dependent: :destroy
  has_many :child_tags,
           through: :tag_selections,
           source: :taggable,
           source_type: 'Tag'
  has_many :recipes,
           through: :tag_selections,
           source: :taggable,
           source_type: 'Recipe'

  # Tags that are assigned to this tag, like Ingredient Type
  has_many :taggings,
           -> { where(taggable_type: 'Tag') },
           foreign_key: :taggable_id,
           foreign_type: 'Tag',
           class_name: 'TagSelection',
           dependent: :destroy
  has_many :tags,
           through: :taggings,
           source: 'tag'

  has_one :access, as: :accessible

  validates :name, presence: true
  validates_uniqueness_of :name, scope: :tag_type
end
