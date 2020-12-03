require 'rails_helper'

RSpec.describe Post, type: :model do
  let!(:protector) { create(:protector) }
  let!(:dog) { build(:dog, protector_id: protector.id) }
  let!(:testpost) { build(:post) }
  let(:testpost2) { build(:post) }

  describe "validation" do
    before do
      dog.image = fixture_file_upload("/files/test.png")
      dog.save
      testpost.dog_id = dog.id
      testpost.image = fixture_file_upload("/files/test.png")
    end

    it "全て入力済みであればバリデーションエラーは発生しないこと" do
      expect(testpost).to be_valid
    end

    it "imageを選択していない場合エラーが発生すること" do
      testpost2.dog_id = dog.id
      expect(testpost2).to be_invalid
    end

    it "contentが空であってもエラーは発生しないこと" do
      testpost.content = ""
      expect(testpost).to be_valid
    end

    it "contentが200文字以上の場合エラーが発生すること" do
      testpost.content = "a " * 201
      expect(testpost).to be_invalid
    end
  end
end
