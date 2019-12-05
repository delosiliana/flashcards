FactoryBot.define do
  factory :card do
    sequence(:original_text) { |n| "Home #{n}" }
    sequence(:translated_text) { |n| "дом #{n}" }
    try_count { "0" }
    mistake_count { "3" }
    #user
  end
end
