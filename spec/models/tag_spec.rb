require 'rails_helper'

describe Tag do
  subject { create :tag }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  it 'has a tag type' do
    expect(subject.tag_type).to be_valid
  end

  describe '#recipe' do
    it 'can be a recipe' do
      recipe = create(:recipe)
      subject.recipe_id = recipe.id
      expect(subject.recipe).to eq(recipe)
    end
  end

  describe '#recipes' do
    let(:cake) { create(:recipe) }
    let(:tag_type) { create :tag_type, name: 'Ingredient' }
    let(:flower) { create :tag, tag_type: tag_type, name: 'Flower' }
    it 'creates ingredients' do
      cake.tag_selections.create([{ tag: flower }])
      expect(flower.recipes).to eq([cake])
    end
  end

  describe '#tags_on_tags' do
    let(:type_ingredient) { create :tag_type, name: 'Ingredient' }
    let(:type_ingredient_type) { create :tag_type, name: 'IngredientType' }
    let!(:nut) { create(:tag, tag_type: type_ingredient_type, name: 'Nut') }
    let!(:almond) { create :tag, tag_type: type_ingredient, name: 'Almond' }
    let!(:tag_selection) { create :tag_selection, tag: nut, taggable: almond }
    it 'creates child_tags' do
      expect(nut.child_tags).to eq([almond])
    end
    it 'has tags' do
      expect(almond.tags).to eq([nut])
    end
  end

  describe '#access' do
    let!(:access) { create(:access, accessible: subject) }
    it 'can have an access' do
      expect(subject.access).to be_valid
    end
  end

  describe '#tag_attributes' do
    let(:tag_attribute) { create(:tag_attribute, tag_attributable: subject) }
    it 'has tag_attributes' do
      expect(subject.tag_attributes).to eq([tag_attribute])
    end
  end

  describe '#validations' do
    let(:tag_type) { create(:tag_type) }
    let(:recipe) { create(:recipe) }
    it 'validates present name' do
      tag = Tag.new(tag_type: tag_type)
      expect(tag).not_to be_valid
    end
    it 'validates present tag type' do
      tag = Tag.new(name: 'Tag Name')
      expect(tag).not_to be_valid
    end
    it 'validates unique tags by taggable entity' do
      Tag.create!(tag_type: tag_type, name: recipe)
      tag = Tag.new(tag_type: tag, name: recipe)
      expect(tag).not_to be_valid
    end
  end
end
