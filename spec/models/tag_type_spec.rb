require 'rails_helper'

describe TagType do
  subject { create :tag_type }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  it 'validates a unique name' do
    TagType.create!(name: 'Same Name')
    tt2 = TagType.new(name: 'Same Name')
    expect(tt2).not_to be_valid
  end
end
