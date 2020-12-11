FactoryBot.define do
  factory :pet do
    age { "１歳" }
    gender { "男の子" }
    character { "test character" }
  end

  factory :pet2, class: "Pet" do
    association :user
    age { "１歳" }
    gender { "男の子" }
    character { "test character" }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, "spec/fixtures/files/test.png"), 'image/png') }

    trait :invalid do
      age { " " }
    end
  end

  factory :pet3, class: "Pet" do
    association :user
    age { "２歳" }
    gender { "男の子" }
    character { "test character" }

    trait :invalid do
      age { " " }
    end
  end
end
