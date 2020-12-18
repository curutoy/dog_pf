FactoryBot.define do
  factory :entry do
    association :user
    association :protector
    association :room
  end
end
