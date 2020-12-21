FactoryBot.define do
  factory :event do
    protector_id { 1 }
    due_on { "2020-12-21" }
    start_at { "2020-12-21 12:39:45" }
    finish_at { "2020-12-21 12:39:45" }
    prefecture { 1 }
    address { "MyString" }
    latitude { 1.5 }
    longitude { 1.5 }
    content { "MyText" }
  end
end
