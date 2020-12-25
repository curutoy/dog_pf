FactoryBot.define do
  factory :event do
    association :protector
    due_on { Date.today }
    start_at { DateTime.now }
    finish_at { DateTime.now }
    prefecture { "東京都" }
    address { "東京都新宿区新宿３丁目３８" }
    content { "test content" }

    trait :invalid do
      address { " " }
    end
  end

  factory :event2, class: "Event" do
    association :protector
    due_on { Date.today }
    start_at { DateTime.now }
    finish_at { DateTime.now }
    prefecture { "千葉県" }
    address { "千葉県千葉市" }
    content { "test content" }

    trait :invalid do
      prefecture { " " }
    end
  end
end
