# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
require_relative '../contexts/recipe_context.rb'

describe Api::RecipesController, type: :controller do
  include_context 'recipes'
  let!(:user) { create(:user) }
  let!(:different_user) { create(:user) }
  let!(:recipe) { create(:recipe) }
  let!(:rating_type) { create(:tag_type, name: 'Rating') }
  let!(:ingredient) { create(:tag, tag_type: tag_type_ingredient) }
  let!(:rating) { create(:tag, name: 'rating', tag_type: rating_type) }
  let!(:tag_selection_ing) { create(:tag_selection, tag: ingredient, taggable: recipe) }
  let!(:tag_selection_rating) { create(:tag_selection, tag: rating, taggable: recipe) }
  let!(:access_ing) { create(:access, accessible: tag_selection_ing, user: user) }
  let!(:access_rating) { create(:access, accessible: tag_selection_rating, user: different_user, status: 'PRIVATE') }
  let(:tag_subject) { create(:tag, name: 'Lemon Verbena', tag_type: tag_type_ingredient_type) }

  describe 'GET - show' do
    before do
      sign_in user
      get :show,
          params: { id: recipe.id },
          format: 'json'
    end
    it 'returns a 200' do
      body = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(body['ingredients'][ingredient.id.to_s]['id']).to eq(tag_selection_ing.id)
      expect(body['ratings']).to be_nil
    end
  end

  describe 'GET - index' do
    before do
      sign_in user
      get :index,
          params: { id: recipe.id },
          format: 'json'
    end
    it 'returns a 200' do
      # TODO: add some real test here
      # make sure to cover filter_tags private method like it was previously in tag_spec.rb
      # describe '#collect_tag_ids' do
      #   let(:tag_subject) { create(:tag, name: 'Lemon Verbena', tag_type: tag_type_ingredient_type) }
      #   let(:array_list) do
      #     [
      #       [tag_subject.id, 'Lemon Verbena'],
      #       [ingredient2.id, 'pepper'],
      #       [ingredient1.id, 'salt'],
      #       [ingredient1_type.id, 'spices'],
      #       [ingredient1_family.id, 'seasoning'],
      #       [modification.id, 'chili infused'],
      #       [lemon_verbena.id, ingredient1_verbena]
      #     ]
      #   end
      # end

      # it 'returns collected tag ids for ingredients' do
      #   expect(tag_subject.filter_tags(recipes) - array_list).to eq([])
      # end

      # and cover filter tags on a modification
      # describe '#collect_tag_ids' do
      #   let(:mod) { create(:tag_type, name: 'IngredientModification') }
      #   let(:tag_subject) { create(:tag, name: 'Chamomile', tag_type: mod) }
      #   let!(:mod_selection) { create(:tag_selection, tag: tag_subject, taggable: tag_selection1)}
      #   let(:filter_array) do
      #     [
      #       [tag_subject.id, 'Chamomile'],
      #       [ingredient2.id, 'pepper'],
      #       [ingredient1.id, 'salt'],
      #       [ingredient1_type.id, 'spices'],
      #       [ingredient1_family.id, 'seasoning'],
      #       [modification.id, 'chili infused'],
      #       [rating.id, 'Rating: 9'],
      #       [lemon_verbena.id, 'Lemon Verbena']
      #     ]
      #   end
      # end
      # it 'returns collected tag ids for modification' do
      #   expect(tag_subject.filter_tags(recipes) - filter_array).to eq([])
      # end
      expect(response.status).to eq(201)
    end
  end
end
