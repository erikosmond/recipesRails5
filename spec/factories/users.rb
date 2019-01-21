FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "user#{n}@example.com"
    end
    sign_up_code { ENV['SIGNUP_CODES'].to_s.split(',').first }
    password { 'password' }
  end
end
