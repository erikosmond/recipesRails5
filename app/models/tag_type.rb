class TagType < ApplicationRecord
  INGREDIENT_TYPES = %w[Ingredient IngredientType IngredientFamily].freeze
  @mutex = Mutex.new

  has_many :tags, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def self.family_id
    @mutex.synchronize do
      @family_id ||= TagType.find_by_name('IngredientFamily').id
    end
  end

  def self.type_id
    @mutex.synchronize do
      @type_id ||= TagType.find_by_name('IngredientType').id
    end
  end

  def self.ingredient_id
    @mutex.synchronize do
      @ingredient_id ||= TagType.find_by_name('Ingredient').id
    end
  end
end
