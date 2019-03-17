# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

describe Api::RecipesController, type: :controller do
  let!(:user) { create(:user) }
  let!(:different_user) { create(:user) }
  let!(:recipe) { create(:recipe) }
  let!(:rating_type) { create(:tag_type, name: 'Rating') }
  let!(:ingredient_type) { create(:tag_type, name: 'Ingredient') }
  let!(:ingredient) { create(:tag, tag_type: ingredient_type) }
  let!(:rating) { create(:tag, name: 'rating', tag_type: rating_type) }
  let!(:tag_selection_ing) { create(:tag_selection, tag: ingredient, taggable: recipe) }
  let!(:tag_selection_rating) { create(:tag_selection, tag: rating, taggable: recipe) }
  let!(:access_ing) { create(:access, accessible: tag_selection_ing, user: user) }
  let!(:access_rating) { create(:access, accessible: tag_selection_rating, user: different_user, status: 'PRIVATE') }
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
end
