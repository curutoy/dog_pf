FactoryBot.define do
  factory :dog do
    name { "testdog" }
    age { "１歳" }
    address { "東京都" }
    gender { "男の子" }
    size { "小型犬" }
    walking { "上手" }
    caretaker { "上手" }
    relationship_dog { "上手" }
    relationship_people { "上手" }
    castration { "済" }
    vaccine { "済" }
    microchip { "済" }
    senior { "応募可能" }
    single_people { "応募可能" }
    profile { "dog_profile_test" }
    health { "dog_health_test" }
    conditions { "dog_conditions_test" }
  end

  factory :dog2, class: "Dog" do
    association :protector
    name { "testdog" }
    age { "１歳" }
    address { "東京都" }
    gender { "男の子" }
    size { "小型犬" }
    walking { "上手" }
    caretaker { "上手" }
    relationship_dog { "上手" }
    relationship_people { "上手" }
    castration { "済" }
    vaccine { "済" }
    microchip { "済" }
    senior { "応募可能" }
    single_people { "応募可能" }
    profile { "dog_profile_test" }
    health { "dog_health_test" }
    conditions { "dog_conditions_test" }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, "spec/fixtures/files/test.png"), 'image/png') }

    trait :invalid do
      name { " " }
    end
  end

  factory :dog3, class: "Dog" do
    association :protector
    name { "testdog3" }
    age { "１歳" }
    address { "東京都" }
    gender { "男の子" }
    size { "小型犬" }
    walking { "上手" }
    caretaker { "上手" }
    relationship_dog { "上手" }
    relationship_people { "上手" }
    castration { "済" }
    vaccine { "済" }
    microchip { "済" }
    senior { "応募可能" }
    single_people { "応募可能" }
    profile { "dog_profile_test" }
    health { "dog_health_test" }
    conditions { "dog_conditions_test" }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, "spec/fixtures/files/test.png"), 'image/png') }

    trait :invalid do
      name { " " }
    end
  end
end
