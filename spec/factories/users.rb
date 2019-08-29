FactoryBot.define do
  sequence(:email) { |n| 'test#{n}@test.com'}
  sequence(:password) { |n| 'password#{n}'}
  sequence(:password_confirmation) { |n| 'password#{n}'}
  sequence(:salt) { |n| 'salt#{n}'}

  factory :user do
    email
    password
    password_confirmation
    salt
  end
end
