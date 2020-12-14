FactoryBot.define do
  factory :relationship do
    association :protector
    association :user
  end
end
