require 'rails_helper'

describe UserRole do
  subject { create :user_role }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  it 'has a user' do
    expect(subject.user).to be_valid
  end

  it 'has a role' do
    expect(subject.role).to be_valid
  end
end
