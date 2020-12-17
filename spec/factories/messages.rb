FactoryBot.define do
  factory :message do
    user { nil }
    protector { nil }
    room { nil }
    content { "MyText" }
  end
end
