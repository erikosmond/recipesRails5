FactoryBot.define do
  factory :access do
    user
    association :accessible, factory: :recipe
    status { 'PUBLIC' }
  end
end
