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

  describe '#validations' do
    let(:recipe) { create(:recipe) }
    let(:tag) { create(:tag) }
    it 'validates present tag_id' do
      ts = TagSelection.new(taggable: recipe)
      expect(ts).not_to be_valid
    end
    it 'validates present taggable' do
      ts = TagSelection.new(tag: tag)
      expect(ts).not_to be_valid
    end
    it 'validates unique tags by taggable entity' do
      TagSelection.create!(tag: tag, taggable: recipe)
      ts = TagSelection.new(tag: tag, taggable: recipe)
      expect(ts).not_to be_valid
    end
  end
end
