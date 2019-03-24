# frozen_string_literal: true

require 'rails_helper'
require_relative '../contexts/tag_context.rb'
require_relative '../contexts/recipe_context.rb'

describe Tag, type: :model do
  before(:each) do
    TagType.unsync_ids
  end

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
    include_context 'tags'
    let(:expected_hierarchy_result) do
      {
        'id' => nut.id,
        'name' => 'Nut',
        'description' => nil,
        'tag_type_id' => nut.tag_type.id,
        'tags' => { nut.id => 'Nut' },
        'recipe_id' => nil,
        'child_tags' => { almond.id => 'Almond' },
        'parent_tags' => { protein.id => 'Protein' },
        'grandparent_tags' => { plants.id => 'plants' },
        'modification_tags' => {
          modification1.id => 'toasted',
          modification2.id => 'crushed'
        },
        'modified_tags' => {},
      }
    end

    it 'creates child_tags' do
      expect(nut.child_tags.count).to eq(1)
      expect(nut.child_tags.first.name).to eq('Almond')
      expect(nut.child_tags.first.class.name).to eq('ChildTag')
    end

    it 'returns all ingredient filters' do
      expected = { protein.id => { nut.id => [almond.id] } }
      expect(Tag.ingredient_group_hierarchy_filters(user)).to eq(expected)
    end

    it 'returns no ingredient filters' do
      expected = {}
      expect(Tag.ingredient_group_hierarchy_filters(non_active_user)).to eq(expected)
    end

    it 'returns tags_by_type' do
      expected = { alteration.id => [toasted.id, crushed.id] }
      expect(Tag.tags_by_type).to eq(expected)
    end

    it 'has parent_tags' do
      expect(almond.parent_tags).to eq([nut])
    end
    it 'has grandparent_tags' do
      expect(almond.grandparent_tags).to eq([protein])
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
    describe 'assigns recipes to ingredient family' do
      it 'has manhattan as a recipe' do
        expect(protein.recipes).to eq([manhattan])
      end
      it 'has vesper as child recipe' do
        expect(protein.child_recipes).to eq([vesper])
      end
      it 'has martini as grandchild recipe' do
        expect(protein.grandchild_recipes).to eq([martini])
      end
    end
    describe 'assigns tags to ingredient family' do
      it 'has one child tag' do
        expect(protein.child_tags.count).to eq(1)
      end
      it 'has nut as child tag' do
        expect(protein.child_tags.first.name).to eq('Nut')
      end
      it 'has child tag class name' do
        expect(protein.child_tags.first.class.name).to eq('ChildTag')
      end
      it 'has almond as grandchild tag' do
        expect(protein.grandchild_tags.first.name).to eq('Almond')
      end
      it 'has grandchild tag class name' do
        expect(protein.grandchild_tags.first.class.name).to eq('GrandchildTag')
      end
    end
    # it 'returns recipe level detail for ingredient family' do
    #   expect(protein.recipe_detail_level(user).map(&:recipe_id).uniq).to eq([martini.id, vesper.id, manhattan.id])
    # end
    # it 'returns recipe level detail for ingredient type' do
    #   expect(nut.recipe_detail_level(user).map(&:recipe_id).uniq).to eq([martini.id, vesper.id])
    # end
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
    include_context 'recipes'
    describe '#collect_tag_ids' do
      let(:tag_subject) { create(:tag, name: 'Lemon Verbena', tag_type: tag_type_ingredient_type) }
      let(:array_list) do
        [
          [tag_subject.id, 'Lemon Verbena'],
          [ingredient2.id, 'pepper'],
          [ingredient1.id, 'salt'],
          [ingredient1_type.id, 'spices'],
          [ingredient1_family.id, 'seasoning'],
          [modification.id, 'chili infused'],
          [lemon_verbena.id, ingredient1_verbena]
        ]
      end
      let(:detail_ids) do
        [
          tag_selection1.id,
          tag_selection1a.id,
          tag_selection2a.id,
          tag_selection2b.id,
          tag_selection2c.id
        ]
      end
      let(:private_ids) do
        [
          tag_selection2a.id,
          tag_selection2b.id,
          tag_selection2c.id
        ]
      end
      it 'returns collected tag ids for ingredients' do
        expect(tag_subject.filter_tags(recipes) - array_list).to eq([])
      end
      it 'returns recipe level detail for ingredients' do
        expect(tag_subject.recipe_detail_level(user).map(&:id).uniq - detail_ids).to eq([])
      end
      it 'returns no recipes for ingredients' do
        expect(tag_subject.recipe_detail_level(non_active_user).map(&:id).uniq - private_ids).to eq([])
      end
    end

    describe '#collect_tag_ids' do
      let(:mod) { create(:tag_type, name: 'IngredientModification') }
      let(:tag_subject) { create(:tag, name: 'Chamomile', tag_type: mod) }
      let!(:mod_selection) { create(:tag_selection, tag: tag_subject, taggable: tag_selection1)}
      let(:filter_array) do
        [
          [tag_subject.id, 'Chamomile'],
          [ingredient2.id, 'pepper'],
          [ingredient1.id, 'salt'],
          [ingredient1_type.id, 'spices'],
          [ingredient1_family.id, 'seasoning'],
          [modification.id, 'chili infused'],
          [rating.id, 'Rating: 9'],
          [lemon_verbena.id, 'Lemon Verbena']
        ]
      end
      let(:detail_ids) do
        [
          tag_selection1.id,
          tag_selection1a.id,
          tag_selection2a.id,
          tag_selection2b.id,
          tag_selection2c.id,
          mod_selection.id
        ]
      end
      it 'returns collected tag ids for modification' do
        expect(tag_subject.filter_tags(recipes) - filter_array).to eq([])
      end
      it 'returns recipe level detail for modification' do
        expect(tag_subject.recipe_detail_level(user).map(&:id).uniq.sort).to eq(detail_ids.sort)
      end
    end

    describe '#recipes_with_grouped_detail' do
      let(:tag_subject) { create(:tag, name: 'Verbena', tag_type: tag_type_ingredient_type) }
      let!(:recipe_result2) { tag_subject.recipes_with_grouped_detail(recipes).second }
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
        expect(recipe_result2['ingredients'][tag_selection2b.tag_id].parent_tag ).to eq(ingredient1_type_name)
      end
      it 'returns ingredient family' do
        expect(recipe_result2['ingredients'][tag_selection2b.tag_id].grandparent_tag ).to eq(ingredient1_family_name)
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
