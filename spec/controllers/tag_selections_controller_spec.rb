# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

describe Api::TagSelectionsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:recipe) { create(:recipe) }
  let!(:tag) { create(:tag) }

  describe 'POST - create' do
    before do
      sign_in user
      put :create,
          params: {
            tag_selection: {
              taggable_type: 'Recipe',
              taggable_id: recipe.id,
              tag_id: tag.id
            }
          },
          format: 'json'
    end
    it 'returns a 200' do
      expect(response.status).to eq(200)
    end
  end
end
