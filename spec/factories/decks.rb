FactoryBot.define do
  factory :deck do
    sequence(:title) { |n| "MyString #{n}" }
    sequence(:current) { false }
    user
  end
end
