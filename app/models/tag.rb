class Tag < ApplicationRecord
  belongs_to :tag_type
  belongs_to :recipe, optional: true
  has_many :tag_attributes, as: :tag_attributable, dependent: :destroy # i.e. Brand, Year

  has_many :tag_selections, dependent: :destroy
  has_many :child_tags,
           through: :tag_selections,
           source: :taggable,
           source_type: 'Tag'
  has_many :recipes,
           through: :tag_selections,
           source: :taggable,
           source_type: 'Recipe',
           inverse_of: :tags

  # Tags that are assigned to this tag, like Ingredient Type
  has_many :taggings,
           foreign_key: :taggable_id,
           foreign_type: 'Tag',
           class_name: 'TagSelection',
           dependent: :destroy
  has_many :tags, through: :taggings, source: 'tag'

  has_one :access, as: :accessible

  validates :name, presence: true
  validates_uniqueness_of :name, scope: :tag_type
end
