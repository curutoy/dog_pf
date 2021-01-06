FactoryBot.define do
  factory :notification do
    association :user
    association :protector
    association :room
    association :message
    action { "dm" }
    checked { false }
  end

  factory :notification2, class: "Notification" do
    association :user
    association :protector
    association :dog
    action { "like" }
    checked { false }
  end

  factory :notification3, class: "Notification" do
    association :user
    association :protector
    action { "follow" }
    checked { false }
  end
end
