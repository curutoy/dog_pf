FactoryBot.define do
  factory :protector do
    name { "testprotector" }
    email { "protector@example.com" }
    address { "東京都" }
    profile { "test" }
    password { "testpassword" }
    password_confirmation { "testpassword" }
  end

  factory :protector2, class: "Protector" do
    name { "testprotector2" }
    email { "protector2@example.com" }
    address { "東京都" }
    profile { "test2" }
    password { "test2password" }
    password_confirmation { "test2password" }
  end
end
