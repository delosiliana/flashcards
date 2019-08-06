FactoryBot.define do
  factory :card do
    sequence(:original_text) { |n| "Original text #{n}" }
    sequence(:translated_text) { |n| "Translated text #{n}" }
  end
end
