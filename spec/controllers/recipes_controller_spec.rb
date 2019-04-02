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
  let(:tag_subject) { create(:tag, name: 'Rice', tag_type: tag_type_ingredient_type) }

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
          params: { tag_id: tag_subject.id },
          format: 'json'
    end

    let(:filter_array) do
      [
        [lemon_verbena.id, 'Lemon Verbena'],
        [tag_subject.id, 'Rice'],
        [ingredient2.id, 'pepper'],
        [ingredient1.id, 'salt'],
        [ingredient1_type.id, 'spices'],
        [ingredient1_family.id, 'seasoning'],
        [modification.id, 'chili infused']]
    end

    it 'returns a 200' do
      expect(response.status).to eq(200)
      body = JSON.parse(response.body)
      expect(body['tag']['id']).to eq(tag_subject.id)
      expect(body['recipes'].size).to eq(2)
      expect(body['recipes'].first['name']).to eq('Pizza')
      expect(body['recipes'].first['ingredients'][lemon_verbena.id.to_s]['tag_type']).to eq 'Ingredient'
      expect(body['recipes'].first['ingredienttypes'].first['tag_name']).to eq('Rice')
      expect(body['filter_tags']).to eq(filter_array)
    end
  end

  describe 'GET - index (modification)' do
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
        [lemon_verbena.id, 'Lemon Verbena']
      ]
    end

    before do
      sign_in user
      get :index,
          params: { tag_id: tag_subject.id },
          format: 'json'
    end

    it 'returns a 200' do
      body = JSON.parse(response.body)
      expect(body['recipes'].size).to eq(2)
      expect(body['filter_tags'] - filter_array).to eq([])
      expect(response.status).to eq(200)
    end
  end
end
