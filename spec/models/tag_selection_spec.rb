# frozen_string_literal: true

require 'rails_helper'

describe TagSelection do
  subject { create :tag_selection }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  describe '#tag_attributes' do
    let(:tag_attribute) { create(:tag_attribute, tag_attributable: subject) }
    it 'has tag_attributes' do
      expect(subject.tag_attributes).to eq([tag_attribute])
    end
  end

  describe '#modification_selections' do
    let(:tag) { create(:tag) }
    it 'has modification_selections' do
      subject.modification_selections.create(tag: tag)
      expect(subject.modifications).to eq([tag])
    end
  end

  describe '#access' do
    let!(:access) { create(:access, accessible: subject) }
    it 'can have an access' do
      expect(subject.access).to eq(access)
    end
  end

  describe '#tag' do
    it 'belongs to valid tag' do
      expect(subject.tag).to be_valid
    end
  end

  describe '#recipe' do
    let(:recipe) { create(:recipe) }
    let(:tag) { create(:tag) }
    let!(:tag_selection) { create(:tag_selection, tag: tag, taggable: recipe) }
    it 'belongs to valid tag' do
      expect(tag_selection.recipe).to eq(recipe)
    end
  end

  describe '#validations' do
    let(:recipe) { create(:recipe) }
    let(:tag) { create(:tag) }
    let(:tsa) { build(:tag_selection, tag_id: nil) }
    let(:tsb) { build(:tag_selection, taggable: nil) }
    let!(:ts1) { create(:tag_selection, tag: tag, taggable: recipe) }
    let!(:ts2) { build(:tag_selection, tag: tag, taggable: recipe) }
    it 'validates present tag_id' do
      expect(tsa).not_to be_valid
    end
    it 'validates present taggable' do
      expect(tsb).not_to be_valid
    end
    it 'validates unique tags by taggable entity' do
      expect(ts2).not_to be_valid
    end
  end
end
