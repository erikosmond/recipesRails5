# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

describe PagesController, type: :controller do
  let!(:user) { create(:user) }
  let!(:recipe) { create(:recipe) }
  let!(:tag) { create(:tag) }

  let!(:ratings_type) { create(:tag_type, name: 'Rating') }
  let!(:rating_tag) { create(:tag, tag_type: ratings_type, name: 'new rating') }
  let!(:priority_type) { create(:tag_type, name: 'Priority') }
  let!(:priority_tag) { create(:tag, tag_type: priority_type, name: 'a priority') }
  let!(:ing_family_type) { create(:tag_type, name: 'IngredientFamily') }
  let!(:family_tag) { create(:tag, tag_type: ing_family_type, name: 'fam tag') }
  let!(:tag_selection) { create(:tag_selection, tag: family_tag, taggable: recipe) }
  let!(:access) { create(:access, accessible: tag_selection, user: user) }
  let(:all_tag_types) do
    {
      TagType.first.id => TagType.first.name,
      TagType.second.id => TagType.second.name,
      TagType.third.id => TagType.third.name,
      TagType.fourth.id => TagType.fourth.name
    }
  end
  let(:tags_by_type) do
    {
      TagType.first.id => [Tag.first.id],
      TagType.second.id => [Tag.second.id],
      TagType.third.id => [Tag.third.id]
    }
  end
  let(:all_tags) do
    {
      Tag.first.id => Tag.first.name,
      Tag.second.id => Tag.second.name,
      Tag.third.id => Tag.third.name,
      Tag.fourth.id => Tag.fourth.name
    }
  end
  let(:tag_groups) { 'fix test setup' }

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

    it { expect(response.status).to eq(200) }
    it { expect(assigns[:all_tags]).to eq(all_tags) }
    it { expect(assigns[:home_tag_id]).to eq(tag.id) }
    it { expect(assigns[:all_tag_types]).to eq(all_tag_types) }
    it { expect(assigns[:tag_groups]).to eq(tag_groups) }
    it { expect(assigns[:tags_by_type]).to eq(tags_by_type) }
    it { expect(assigns[:ratings]).to eq(rating_tag.name => rating_tag.id) }
    it { expect(assigns[:priorities]).to eq(priority_tag.name => priority_tag.id) }

    it { is_expected.to render_template :home }
  end
end
