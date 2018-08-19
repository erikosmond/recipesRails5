require 'rails_helper'

describe TagAttribute do
  subject { create :tag_attribute }
  let(:tag) { create(:tag) }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  it 'must have a property' do
    tag_attr = TagAttribute.new(tag_attributable: tag)
    expect(tag_attr).not_to be_valid
  end

  it 'validates unqiue property per tag attributable' do
    TagAttribute.create(tag_attributable: tag, property: 'Same Prop')
    tag_attr = TagAttribute.new(tag_attributable: tag, property: 'Same Prop')
    expect(tag_attr).not_to be_valid
  end
end
