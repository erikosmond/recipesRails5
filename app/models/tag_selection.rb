class TagSelection < ApplicationRecord
  has_many :tag_attributes, as: :tag_attributable, dependent: :destroy # i.e. Amount
  has_many :modification_selections,
           class_name: 'TagSelection',
           as: :taggable,
           dependent: :destroy
  has_many :modifications, through: :modification_selections, source: :tag

  has_one :access, as: :accessible

  belongs_to :tag, inverse_of: :tag_selections
  belongs_to :taggable,
             polymorphic: true,
             optional: true

  belongs_to :recipe, # -> { where(tag_selections: { taggable_type: 'Recipe' }) },
             optional: true,
             foreign_key: 'taggable_id',
             foreign_type: 'taggable_type',
             class_name: 'Recipe'

  # belongs_to :recipe, -> { where('tag_selections.taggable_type = ?', 'Recipe') },
  #            foreign_key: 'taggable_id'

  validates :tag_id, presence: true
  validates :taggable_type, presence: true
  validates :taggable_id, presence: true

  validates_uniqueness_of :tag_id, scope: %i[taggable_id taggable_type]

  accepts_nested_attributes_for :tag_attributes

end
