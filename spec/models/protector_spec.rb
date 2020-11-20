require 'rails_helper'

RSpec.describe Protector, type: :model do
  let(:testprotector1) { FactoryBot.build(:protector) }
  let(:testprotector2) { FactoryBot.build(:protector2) }

  before do
    testprotector1.image = fixture_file_upload("/files/test.png")
  end

  describe "validation" do
    it "全て入力済みであればバリデーションエラーは発生しないこと" do
      expect(testprotector1).to be_valid
    end

    it "nameが空白の場合エラーが発生すること" do
      testprotector1.name = ""
      expect(testprotector1).to be_invalid
    end

    it "nameが20文字以上の場合エラーが発生すること" do
      testprotector1.name = "a" * 21
      expect(testprotector1).to be_invalid
    end

    it "emailが空白の場合エラーが発生すること" do
      testprotector1.email = ""
      expect(testprotector1).to be_invalid
    end

    it "emailが20文字以上の場合エラーが発生すること" do
      testprotector1.email = "a" * 49 + "@example.com"
      expect(testprotector1).to be_invalid
    end

    it "emailがuniqueでない場合エラーが発生すること" do
      testprotector2.save
      testprotector1.email = "protector2@example.com"
      expect(testprotector1).to be_invalid
    end

    it "profileが空白の場合エラーは発生しないこと" do
      testprotector1.profile = ""
      expect(testprotector1).to be_valid
    end

    it "profileが200文字以上の場合エラーが発生すること" do
      testprotector1.name = "a" * 201
      expect(testprotector1).to be_invalid
    end

    it "imageを選択しなくてもエラーは発生しないこと" do
      expect(testprotector2).to be_valid
    end

    it "passwordが空白の場合エラーが発生すること" do
      testprotector1.password = ""
      expect(testprotector1).to be_invalid
    end

    it "passwordが6文字以下の場合エラーが発生すること" do
      testprotector1.password = "a" * 5
      expect(testprotector1).to be_invalid
    end

    it "passwordがuniqueでない場合エラーが発生すること" do
      testprotector2.save
      testprotector1.password = "test2password"
      expect(testprotector1).to be_invalid
    end
  end
end
