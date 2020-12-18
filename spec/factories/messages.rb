FactoryBot.define do
  factory :message do
    association :user
    association :protector
    association :room
    content { "test message" }
  end
end
