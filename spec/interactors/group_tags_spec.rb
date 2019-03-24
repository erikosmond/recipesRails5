# frozen_string_literal: true

require 'rails_helper'
require_relative './tag_context.rb'

RSpec.describe GroupTags, type: :interactor do
  describe '.call' do
    include_context 'tags' # from './tag_context.rb'
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
          toasted.id => 'toasted',
          crushed.id => 'crushed'
        },
        'modified_tags' => {}
      }
    end
    it 'will test something' do
      hierarchy_result = BuildTagHierarchy.call(
        tag: nut,
        current_user: user
      )
      result = GroupTags.call(
        tag: nut,
        current_user: user,
        tags_with_hierarchy: hierarchy_result.tags_with_hierarchy
      )
      expect(result.json).to eq expected_hierarchy_result
    end
  end
end
