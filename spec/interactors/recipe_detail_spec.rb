# frozen_string_literal: true

require 'rails_helper'
require_relative '../contexts/recipe_context.rb'

RSpec.describe RecipeDetail, type: :interactor do
  describe '.call' do
    include_context 'recipes'
    let(:tag_subject) { create(:tag, name: 'Marinara', tag_type: tag_type_ingredient_type) }
    let!(:access2b) { create(:access, user: user, accessible: tag_selection2b, status: 'PRIVATE') }
    let!(:access2c) { create(:access, user: non_active_user, accessible: tag_selection2c, status: 'PRIVATE') }

    let(:result) do
      RecipeDetail.call(
        recipe: soup,
        current_user: user
      ).result
    end

    it "returns correct number of recipe's details" do
      expect(result.size).to eq 2
    end
    it 'returns correct first tag name' do
      expect(result.first.tag_name).to eq 'Marinara'
    end
    it 'returns correct second tag name' do
      expect(result.second.tag_name).to eq 'salt'
    end
    it 'returns correct second tag modification' do
      expect(result.second.modifications.first.name).to eq 'chili infused'
    end
    it 'returns correct second tag attribute value' do
      expect(result.second.value).to eq '1 ounce'
    end
    it 'returns correct second tag attribute property' do
      expect(result.second.property).to eq 'Amount'
    end
  end
end
