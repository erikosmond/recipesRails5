# frozen_string_literal: true

class Tag < ApplicationRecord
  include AssociatedRecipesService
  include AssociatedTagsService

  belongs_to :tag_type
  belongs_to :recipe, optional: true, inverse_of: :ingredient
  has_many :tag_attributes, # i.e. Brand, Year
           -> { where(tag_attributable_type: 'Tag') },
           as: :tag_attributable,
           dependent: :destroy

  has_many :tag_selections,
           dependent: :destroy
  has_many :recipes,
           through: :tag_selections,
           source: :taggable,
           source_type: 'Recipe'
  has_many :recipe_tag_selections,
           through: :recipes,
           source: :tag_selections
  has_many :child_tags,
           through: :tag_selections,
           source: :taggable,
           class_name: 'ChildTag',
           source_type: 'Tag'
  has_many :child_tag_selections,
           through: :child_tags,
           source: :tag_selections
  has_many :child_recipes,
           through: :child_tag_selections,
           source: :taggable,
           source_type: 'Recipe'
  has_many :child_recipe_tag_selections,
           through: :child_recipes,
           source: :tag_selections
  has_many :grandchild_tags,
           through: :child_tag_selections,
           source: :taggable,
           class_name: 'GrandchildTag',
           source_type: 'Tag'
  has_many :grandchild_tag_selections,
           through: :grandchild_tags,
           source: :tag_selections
  has_many :grandchild_recipes,
           through: :grandchild_tag_selections,
           source: :taggable,
           source_type: 'Recipe'
  has_many :grandchild_recipe_tag_selections,
           through: :grandchild_recipes,
           source: :tag_selections

  # Tags that are assigned to this tag, like Ingredient Type
  has_many :taggings,
           -> { where(taggable_type: 'Tag') },
           foreign_key: :taggable_id,
           foreign_type: 'Tag',
           class_name: 'TagSelection',
           dependent: :destroy
  has_many :parent_tags,
           through: :taggings,
           source: 'tag'
  has_many :parent_taggings,
           through: :parent_tags,
           source: :taggings
  has_many :grandparent_tags,
           through: :parent_taggings,
           source: 'tag'

  has_one :access, as: :accessible

  validates :name, presence: true
  validates_uniqueness_of :name, scope: :tag_type
end
