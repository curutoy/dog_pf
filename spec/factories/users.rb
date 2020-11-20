FactoryBot.define do
  factory :user do
    name { "testuser" }
    email { "test@example.com" }
    address { "東京都" }
    family_people { "１人" }
    house { "一戸建て" }
    caretaker { "無" }
    profile { "test" }
    password { "testpassword" }
    password_confirmation { "testpassword" }
  end

  factory :user2, class: "User" do
    name { "testuser2" }
    email { "test2@example.com" }
    address { "東京都" }
    family_people { "１人" }
    house { "一戸建て" }
    caretaker { "無" }
    profile { "test2" }
    password { "test2password" }
    password_confirmation { "test2password" }
  end
end
