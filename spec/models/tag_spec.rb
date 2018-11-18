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
    let(:type_ingredient_family) { create :tag_type, name: 'IngredientFamily' }
    let(:type_ingredient_category) { create :tag_type, name: 'IngredientCategory' }
    let(:plants) { create(:tag, tag_type: type_ingredient_category, name: 'plants') }
    let(:protein) { create(:tag, tag_type: type_ingredient_family, name: 'Protein') }
    let(:nut) { create(:tag, tag_type: type_ingredient_type, name: 'Nut') }
    let(:almond) { create :tag, tag_type: type_ingredient, name: 'Almond' }
    let!(:tag_selection1) { create :tag_selection, tag: nut, taggable: almond }
    let!(:tag_selection2) { create :tag_selection, tag: protein, taggable: nut }
    let!(:tag_selection3) { create :tag_selection, tag: plants, taggable: protein }

    let(:vesper) { create :recipe, name: 'Vesper' }
    let(:martini) { create :recipe, name: 'Martini' }
    let(:manhattan) { create :recipe, name: 'Manhattan' }
    let!(:tag_selection4) { create :tag_selection, tag: nut, taggable: vesper }
    let!(:tag_selection5) { create :tag_selection, tag: almond, taggable: martini }
    let!(:tag_selection6) { create :tag_selection, tag: protein, taggable: manhattan }
    it 'creates child_tags' do
      expect(nut.child_tags.count).to eq(1)
      expect(nut.child_tags.first.name).to eq('Almond')
      expect(nut.child_tags.first.class.name).to eq('ChildTag')
    end
    it 'has tags' do
      expect(almond.tags).to eq([nut])
    end
    it 'assigns recipe to ingredient' do
      expect(nut.recipes).to eq([vesper])
    end
    it 'assigns recipe to ingredient type' do
      expect(almond.recipes).to eq([martini])
    end
    it 'assigns child recipe to ingredient type' do
      expect(nut.child_tag_selections).to eq([tag_selection5])
    end
    it 'assigns recipes to ingredient family' do
      expect(protein.recipes).to eq([manhattan])
      expect(protein.child_recipes).to eq([vesper])
      expect(protein.grandchild_recipes).to eq([martini])
    end
    it 'assigns tags to ingredient family' do
      expect(protein.child_tags.count).to eq(1)
      expect(protein.child_tags.first.name).to eq('Nut')
      expect(protein.child_tags.first.class.name).to eq('ChildTag')
      expect(protein.grandchild_tags.first.name).to eq('Almond')
      expect(protein.grandchild_tags.first.class.name).to eq('GrandchildTag')
      expect(protein.grandchild_recipes_with_detail.to_a.size).to eq(1)
      expect(protein.grandchild_recipes_with_detail.first['recipe_id']).to eq(martini.id)
    end
    it 'assigns child recipe to family' do
      expect(protein.child_recipes_with_detail.to_a.size).to eq(1)
      expect(protein.child_recipes_with_detail.first['recipe_id']).to eq(vesper.id)
    end
    it 'assigns own recipe to family' do
      expect(protein.recipes_with_detail.to_a.size).to eq(1)
      expect(protein.recipes_with_detail.first['recipe_id']).to eq(manhattan.id)
    end
    it 'assigns child recipe to type' do
      expect(nut.child_recipes_with_detail.to_a.size).to eq(1)
      expect(nut.child_recipes_with_detail.first['recipe_id']).to eq(martini.id)
    end
    it 'assigns own recipe to type' do
      expect(nut.recipes_with_detail.to_a.size).to eq(1)
      expect(nut.recipes_with_detail.first['recipe_id']).to eq(vesper.id)
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

  describe '#recipes_with_grouped_detail' do
    let(:modification_name) { 'chili infused' }
    let(:recipe1_name) { 'Pizza' }
    let(:recipe1_description) { 'New York Style' }
    let(:recipe2_name) { 'Chesnut Soup' }
    let(:recipe2_description) { 'Winter Warmer' }
    let(:recipe2_instructions) { 'Stir the soup' }
    let(:ingredient1_name) { 'salt' }
    let(:ingredient2_name) { 'pepper' }
    let(:ingredient1_type_name) { 'spices' }
    let(:ingredient1_family_name) { 'seasoning' }
    let(:property) { 'Amount' }
    let(:value) { '1 ounce' }
    let(:recipe1) { create(:recipe, name: recipe1_name, description: recipe1_description) }
    let(:recipe2) { create(:recipe, name: recipe2_name, description: recipe2_description, instructions: recipe2_instructions) }
    let(:tag_type_ingredient) { create(:tag_type, name: 'Ingredient') }
    let(:tag_type_ingredient_type) { create(:tag_type, name: 'IngredientType') }
    let(:tag_type_ingredient_family) { create(:tag_type, name: 'IngredientFamily') }
    let(:tag_type_not_ingredient) { create(:tag_type, name: 'NotIngredient') }
    let(:alteration) { create(:tag_type, name: 'Alteration') }
    let(:ingredient1) { create(:tag, tag_type: tag_type_ingredient, name: ingredient1_name) }
    let(:ingredient1_type) { create(:tag, tag_type: tag_type_ingredient_type, name: ingredient1_type_name) }
    let(:ingredient1_family) { create(:tag, tag_type: tag_type_ingredient_family, name: ingredient1_family_name) }
    let(:ingredient1_unrelated) { create(:tag, tag_type: tag_type_not_ingredient, name: 'not related') }
    let(:ingredient2) { create(:tag, tag_type: tag_type_ingredient, name: ingredient2_name) }
    let(:modification) { create(:tag, tag_type: alteration, name: modification_name) }
    let!(:tag_selection1) { create(:tag_selection, tag: subject, taggable: recipe1) }
    let!(:tag_selection2a) { create(:tag_selection, tag: subject, taggable: recipe2) }
    let!(:tag_selection2b) { create(:tag_selection, tag: ingredient1, taggable: recipe2) }
    let!(:tag_selection2c) { create(:tag_selection, tag: ingredient2, taggable: recipe2) }
    let!(:tag_selection2ba) { create(:tag_selection, tag: ingredient1_type, taggable: ingredient1) }
    let!(:tag_selection2bb) { create(:tag_selection, tag: ingredient1_family, taggable: ingredient1_type) }
    let!(:tag_attribute) { create(:tag_attribute, property: property, value: value, tag_attributable: tag_selection2b) }
    let!(:tag_selection_mod) { create(:tag_selection, tag: modification, taggable: tag_selection2b) }
    let!(:recipes) { subject.recipes_with_detail }

    describe '#collect_tag_ids' do
      let(:hash) do
        {
          subject.id => true,
          ingredient1.id => true,
          ingredient1_type.id => true,
          ingredient1_family.id => true,
          ingredient2.id => true
        }
      end
      it 'returns collected tag ids' do
        expect(subject.filter_tags(recipes)).to eq(hash)
      end
    end

    describe '#recipes_with_grouped_detail' do
      let!(:recipe_result2) { subject.recipes_with_grouped_detail(recipes).second }
      it 'returns only one valid row' do
        expect(subject.recipes_with_grouped_detail(recipes).count).to eq(2)
      end
      it 'returns recipe name' do
        expect(recipe_result2['name']).to eq(recipe2_name)
      end
      it 'returns recipe description' do
        expect(recipe_result2['description']).to eq(recipe2_description)
      end
      it 'returns recipe instructions' do
        expect(recipe_result2['instructions']).to eq(recipe2_instructions)
      end
      it 'returns modification name' do
        expect(recipe_result2['ingredients'][tag_selection2b.tag_id].modification_name).to eq(modification_name)
      end
      it 'returns tag name' do
        expect(recipe_result2['ingredients'][tag_selection2b.tag_id].tag_name ).to eq(ingredient1_name)
      end
      it 'returns value attribute' do
        expect(recipe_result2['ingredients'][tag_selection2b.tag_id].value ).to eq(value)
      end
      it 'returns property attribute' do
        expect(recipe_result2['ingredients'][tag_selection2b.tag_id].property ).to eq(property)
      end
      it 'returns ingredient type' do
        expect(recipe_result2['ingredients'][tag_selection2b.tag_id].ingredient_type ).to eq(ingredient1_type_name)
      end
      it 'returns ingredient family' do
        expect(recipe_result2['ingredients'][tag_selection2b.tag_id].ingredient_family ).to eq(ingredient1_family_name)
      end
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
