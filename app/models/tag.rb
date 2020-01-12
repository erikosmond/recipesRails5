# frozen_string_literal: true

# Tags are how recipes are grouped and filtered. Types of tags include ingredient,
# recipe author (source), ratings, etc. By using a single table for all of these
# attributes, the filtering implementation on the front end is very simple. It
# also allows the creation of new types of tags through the product, without
# requiring code changes.

# Tags can associate with recipes, but they can also associate with other tags.
# For instance, 'egg white' is an ingredient, which is tagged by 'egg', which is an
# ingredient type, which is tagged by 'dairy', which is an ingredient category.
# But 'egg white', 'egg', and 'dairy' are all tags. This allows the user to filter by
# 'dairy', for instance, and see all the recipes that contain the 'dairy' tag, but
# also the 'egg' and 'egg white' tag.

# Adminitedly, this strategy results in a data model that has the tags class
# contain a lot of associations, which has a lot of undesired complexity.
# Although complex, the data model allows for arbitrary and flexible grouping
# of recipes which I find valuable as I explore the ideal uses for the data.
# I also learned some interesting things about rails associations along the way.
# If I were to implement this app differently, I would consider STI, but I'd be more
# interested in using seperate tables for each tag type, and having the tables
# share a sequence for the primary id, which would allow for the filtering to
# still be simple on the front end.
class Tag < ApplicationRecord
  include AssociatedRecipesService
  include AssociatedTagsService
  extend TagsService

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
  has_many :modified_recipes,
           through: :tag_selections,
           source: :modified_recipes
  has_many :modified_recipe_tag_selections,
           -> { where(taggable_type: 'Recipe') },
           through: :modified_recipes,
           source: :tag_selections
  has_many :modified_tags,
           through: :tag_selections,
           source: :modified_tags
  has_many :modified_tag_tag_selections,
           -> { where(taggable_type: 'TagSelection') },
           through: :modified_tags,
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

  # Tags that are assigned to this tag, like Ingredient Type for an Ingredient
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

  has_one :access, as: :accessible, dependent: :destroy

  validates :name, presence: true
  validates_uniqueness_of :name, scope: :tag_type

  delegate :name, to: :tag_type, prefix: true
end
