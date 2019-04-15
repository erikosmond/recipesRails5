class TagType < ApplicationRecord
  INGREDIENT_TYPES = %w[Ingredient IngredientType IngredientFamily].freeze
  TAG_TYPES = 'tag_types'.freeze
  INGREDIENT_FAMILY = 'IngredientFamily'.freeze
  INGREDIENT_TYPE = 'IngredientType'.freeze
  INGREDIENT_MODIFICATION = 'IngredientModification'.freeze
  INGREDIENT = 'Ingredient'.freeze

  has_many :tags, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def self.family_id
    Rails.cache.fetch("#{TAG_TYPES}/family_id", expires_in: 1.year) do
      TagType.find_by_name(INGREDIENT_FAMILY).id
    end
  end

  def self.type_id
    Rails.cache.fetch("#{TAG_TYPES}/type_id", expires_in: 1.year) do
      TagType.find_by_name(INGREDIENT_TYPE).id
    end
  end

  def self.modification_id
    Rails.cache.fetch("#{TAG_TYPES}/modification_id", expires_in: 1.year) do
      TagType.find_by_name(INGREDIENT_MODIFICATION).id
    end
  end

  def self.ingredient_id
    Rails.cache.fetch("#{TAG_TYPES}/ingredient_id", expires_in: 1.year) do
      TagType.find_by_name(INGREDIENT).id
    end
  end

  def self.unsync_ids
    Rails.cache.delete_matched("#{TAG_TYPES}/*")
  end
end
