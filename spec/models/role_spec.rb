require 'rails_helper'

describe Role do
  subject { create :role }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  it 'validates a unique name' do
    Role.create!(name: 'Same Name')
    role = Role.new(name: 'Same Name')
    expect(role).not_to be_valid
  end
end
