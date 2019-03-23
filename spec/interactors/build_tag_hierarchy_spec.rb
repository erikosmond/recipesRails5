# frozen_string_literal: true

require 'rails_helper'
require_relative './tag_context.rb'

RSpec.describe BuildTagHierarchy, type: :interactor do
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
          modification1.id => 'toasted',
          modification2.id => 'crushed'
        },
        'modified_tags' => {}
      }
    end

    it "returns a tag's parent and child tags" do
      result = BuildTagHierarchy.call(
        tag: nut,
        current_user: user
      )
      expect(result.tags_with_hierarchy.map(&:to_json)).to eq expected_hierarchy_result
    end
  end
end
