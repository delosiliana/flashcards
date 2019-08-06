FactoryBot.define do
  factory :card do
    sequence(:original_text) { |n| "Home #{n}" }
    sequence(:translated_text) { |n| "дом #{n}" }
  end
end
