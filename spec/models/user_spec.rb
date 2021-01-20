require 'rails_helper'

RSpec.describe User, type: :model do
  let(:testuser1) { FactoryBot.build(:user) }
  let(:testuser2) { FactoryBot.build(:user2) }

  before do
    testuser1.image = fixture_file_upload("/files/test.png")
  end

  describe "validation" do
    it "全て入力済みであればバリデーションエラーは発生しないこと" do
      expect(testuser1).to be_valid
    end

    it "nameが空白の場合エラーが発生すること" do
      testuser1.name = ""
      expect(testuser1).to be_invalid
    end

    it "nameが20文字以上の場合エラーが発生すること" do
      testuser1.name = "a" * 21
      expect(testuser1).to be_invalid
    end

    it "emailが空白の場合エラーが発生すること" do
      testuser1.email = ""
      expect(testuser1).to be_invalid
    end

    it "emailが20文字以上の場合エラーが発生すること" do
      testuser1.email = "a" * 49 + "@example.com"
      expect(testuser1).to be_invalid
    end

    it "emailがuniqueでない場合エラーが発生すること" do
      testuser2.save
      testuser1.email = "test2@example.com"
      expect(testuser1).to be_invalid
    end

    it "addressが空白の場合エラーは発生しないこと" do
      testuser1.address = ""
      expect(testuser1).to be_valid
    end

    it "family_peopleが空白の場合エラーは発生しないこと" do
      testuser1.family_people = ""
      expect(testuser1).to be_valid
    end

    it "houseが空白の場合エラーは発生しないこと" do
      testuser1.house = ""
      expect(testuser1).to be_valid
    end

    it "caretakerが空白の場合エラーは発生しないこと" do
      testuser1.caretaker = ""
      expect(testuser1).to be_valid
    end

    it "profileが空白の場合エラーは発生しないこと" do
      testuser1.profile = ""
      expect(testuser1).to be_valid
    end

    it "profileが200文字以上の場合エラーが発生すること" do
      testuser1.profile = "a" * 201
      expect(testuser1).to be_invalid
    end

    it "imageを選択しなくてもエラーは発生しないこと" do
      expect(testuser2).to be_valid
    end

    it "passwordが空白の場合エラーが発生すること" do
      testuser1.password = ""
      expect(testuser1).to be_invalid
    end

    it "passwordが6文字以下の場合エラーが発生すること" do
      testuser1.password = "a" * 5
      expect(testuser1).to be_invalid
    end

    it "passwordがuniqueでない場合エラーが発生すること" do
      testuser2.save
      testuser1.password = "test2password"
      expect(testuser1).to be_invalid
    end
  end
end
