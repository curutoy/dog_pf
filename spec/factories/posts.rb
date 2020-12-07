FactoryBot.define do
  factory :post do
    content { "post content" }
  end

  factory :post2, class: "Post" do
    association :dog
    content { "post content" }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, "spec/fixtures/files/test.png"), 'image/png') }
  end
end
