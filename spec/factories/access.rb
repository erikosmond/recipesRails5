FactoryBot.define do
  factory :access do
    user
    association :accessible, factory: :recipe
    status 'read-only'
  end
end
