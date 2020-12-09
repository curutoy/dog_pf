FactoryBot.define do
  factory :pet do
    age { 1 }
    gender { 1 }
    character { "MyString" }
    user { nil }
  end
end
