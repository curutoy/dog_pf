require 'rails_helper'

RSpec.describe Dog, type: :model do
  let!(:protector) { create(:protector) }
  let(:testdog)  { FactoryBot.build(:dog, protector_id: protector.id) }
  let(:testdog2) { FactoryBot.build(:dog, protector_id: protector.id) }

  before do
    testdog.image = fixture_file_upload("/files/test.png")
  end

  describe "validation" do
    it "全て入力済みであればバリデーションエラーは発生しないこと" do
      expect(testdog).to be_valid
    end

    it "imageを選択していない場合エラーが発生すること" do
      expect(testdog2).to be_invalid
    end

    it "nameが空白の場合エラーが発生すること" do
      testdog.name = ""
      expect(testdog).to be_invalid
    end

    it "nameが20文字以上の場合エラーが発生すること" do
      testdog.name = "a" * 21
      expect(testdog).to be_invalid
    end

    it "ageが空白の場合エラーが発生すること" do
      testdog.age = ""
      expect(testdog).to be_invalid
    end

    it "addressが空白の場合エラーが発生すること" do
      testdog.address = ""
      expect(testdog).to be_invalid
    end

    it "genderが空白の場合エラーが発生すること" do
      testdog.gender = ""
      expect(testdog).to be_invalid
    end

    it "sizeが空白の場合エラーが発生すること" do
      testdog.size = ""
      expect(testdog).to be_invalid
    end

    it "walkingが空白の場合エラーが発生すること" do
      testdog.walking = ""
      expect(testdog).to be_invalid
    end

    it "caretakerが空白の場合エラーが発生すること" do
      testdog.caretaker = ""
      expect(testdog).to be_invalid
    end

    it "relationship_dogが空白の場合エラーが発生すること" do
      testdog.relationship_dog = ""
      expect(testdog).to be_invalid
    end

    it "relationship_peopleが空白の場合エラーが発生すること" do
      testdog.relationship_people = ""
      expect(testdog).to be_invalid
    end

    it "castrationが空白の場合エラーが発生すること" do
      testdog.castration = ""
      expect(testdog).to be_invalid
    end

    it "vaccineが空白の場合エラーが発生すること" do
      testdog.vaccine = ""
      expect(testdog).to be_invalid
    end

    it "microchipが空白の場合エラーが発生すること" do
      testdog.microchip = ""
      expect(testdog).to be_invalid
    end

    it "seniorが空白の場合エラーが発生すること" do
      testdog.senior = ""
      expect(testdog).to be_invalid
    end

    it "single_peopleが空白の場合エラーが発生すること" do
      testdog.single_people = ""
      expect(testdog).to be_invalid
    end

    it "profileが空白の場合エラーは発生しないこと" do
      testdog.profile = ""
      expect(testdog).to be_valid
    end

    it "profileが200文字以上の場合エラーが発生すること" do
      testdog.profile = "a" * 201
      expect(testdog).to be_invalid
    end

    it "healthが空白の場合エラーは発生しないこと" do
      testdog.health = ""
      expect(testdog).to be_valid
    end

    it "healthが200文字以上の場合エラーが発生すること" do
      testdog.health = "a" * 201
      expect(testdog).to be_invalid
    end

    it "conditionsが空白の場合エラーは発生しないこと" do
      testdog.conditions = ""
      expect(testdog).to be_valid
    end

    it "conditionsが200文字以上の場合エラーが発生すること" do
      testdog.conditions = "a" * 201
      expect(testdog).to be_invalid
    end
  end
end
