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

  describe '#recipes_with_detail' do
    let(:modification_name) { 'chili infused' }
    let(:recipe1_name) { 'Pizza' }
    let(:recipe1_description) { 'New York Style' }
    let(:recipe2_name) { 'Chesnut Soup' }
    let(:recipe2_description) { 'Winter Warmer' }
    let(:recipe2_instructions) { 'Stir the soup' }
    let(:ingredient1_name) { 'salt' }
    let(:ingredient2_name) { 'pepper' }
    let(:property) { 'Amount' }
    let(:value) { '1 ounce' }
    let(:recipe1) { create(:recipe, name: recipe1_name, description: recipe1_description) }
    let(:recipe2) { create(:recipe, name: recipe2_name, description: recipe2_description, instructions: recipe2_instructions) }
    let(:tag_type) { create(:tag_type, name: 'Ingredient') }
    let(:alteration) { create(:tag_type, name: 'Alteration') }
    let(:ingredient1) { create(:tag, tag_type: tag_type, name: ingredient1_name) }
    let(:ingredient2) { create(:tag, tag_type: tag_type, name: ingredient2_name) }
    let(:modification) { create(:tag, tag_type: alteration, name: modification_name) }
    let!(:tag_selection1) { create(:tag_selection, tag: subject, taggable: recipe1) }
    let!(:tag_selection2a) { create(:tag_selection, tag: subject, taggable: recipe2) }
    let!(:tag_selection2b) { create(:tag_selection, tag: ingredient1, taggable: recipe2) }
    let!(:tag_selection2c) { create(:tag_selection, tag: ingredient2, taggable: recipe2) }
    let!(:tag_attribute) { create(:tag_attribute, property: property, value: value, tag_attributable: tag_selection2b) }
    let!(:tag_selection_mod) { create(:tag_selection, tag: modification, taggable: tag_selection2b) }
    let(:recipe_result1) { subject.recipes_with_grouped_detail.first }
    let(:recipe_result2) { subject.recipes_with_grouped_detail.second }
    it 'returns recipes with detail' do
      expect(recipe_result2['name']).to eq(recipe2_name)
      expect(recipe_result2['description']).to eq(recipe2_description)
      expect(recipe_result2['instructions']).to eq(recipe2_instructions)
      expect(recipe_result2['ingredients'][tag_selection2b.tag_id].modification_name).to eq(modification_name)
      expect(recipe_result2['ingredients'][tag_selection2b.tag_id].tag_name ).to eq(ingredient1_name)
      expect(recipe_result2['ingredients'][tag_selection2b.tag_id].value ).to eq(value)
      expect(recipe_result2['ingredients'][tag_selection2b.tag_id].property ).to eq(property)
    end
  end

  describe '#validations' do
    let(:tag_type) { create(:tag_type) }
    let(:recipe) { create(:recipe) }
    let(:taga) { build(:tag, name: nil) }
    let(:tagb) { build(:tag, tag_type: nil) }
    let!(:tag1) { create(:tag, tag_type: tag_type, name: 'Same Name') }
    let!(:tag2) { build(:tag, tag_type: tag_type, name: 'Same Name') }

    it 'validates present name' do
      expect(taga).not_to be_valid
    end
    it 'validates present tag type' do
      expect(tagb).not_to be_valid
    end
    it 'validates unique tags by taggable entity' do
      expect(tag2).not_to be_valid
    end
  end
end
