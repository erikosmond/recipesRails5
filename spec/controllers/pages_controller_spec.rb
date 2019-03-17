# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

describe PagesController, type: :controller do
  let!(:user) { create(:user) }
  let!(:recipe) { create(:recipe) }
  let!(:tag) { create(:tag) }

  let!(:ratings_type) { create(:tag_type, name: 'Rating') }
  let!(:priority_type) { create(:tag_type, name: 'Priority') }
  let!(:ing_family_type) { create(:tag_type, name: 'IngredientFamily') }

  describe 'GET - home' do
    before do
      sign_in user
      get :home,
          params: {
            tag_selection: {
              taggable_type: 'Recipe',
              taggable_id: recipe.id,
              tag_id: tag.id
            }
          },
          format: 'html'
    end
    it 'resonds with 200' do
      expect(response.status).to eq(200)
    end
  end
end
