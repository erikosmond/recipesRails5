# frozen_string_literal: true

class TagSelection < ApplicationRecord
  has_many :tag_attributes, # i.e. Amount
           -> { where(tag_attributable_type: 'TagSelection') },
           as: :tag_attributable, dependent: :destroy
  has_many :modification_selections,
           -> { where(taggable_type: 'TagSelection') },
           class_name: 'TagSelection',
           as: :taggable,
           dependent: :destroy
  has_many :modifications, through: :modification_selections, source: :tag

  has_one :access, as: :accessible

  belongs_to :tag,
             # optional: true,
             inverse_of: :tag_selections
  belongs_to :taggable,
             polymorphic: true,
             optional: true
  belongs_to :recipe,
             # inverse_of: :tag_selections,
             optional: true,
             foreign_key: 'taggable_id',
             foreign_type: 'taggable_type',
             class_name: 'Recipe'

  # has_many :child_recipe_tags,
  #         through: :child_recipe_tag_selections,
  #         source: :tag
  belongs_to :child_tag,
             foreign_key: 'tag_id',
             class_name: 'ChildTag' #,
             # optional: true,

  has_many :child_recipe_tags,
           through: :recipe # ,

  # belongs_to :recipe_tag_selection,
  #            through: recipe

  validates :tag_id, presence: true
  validates :taggable_type, presence: true
  validates :taggable_id, presence: true

  validates_uniqueness_of :tag_id, scope: %i[taggable_id taggable_type]

  accepts_nested_attributes_for :tag_attributes
end
