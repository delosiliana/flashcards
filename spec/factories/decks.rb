FactoryBot.define do
  factory :deck do
    sequence(:title) { |n| "MyString #{n}" }
    user
  end
end
