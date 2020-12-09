require 'rails_helper'

RSpec.describe Pet, type: :model do
  let!(:user) { create(:user) }
  let(:pet1)  { build(:pet, user_id: user.id) }
  let(:pet2)  { build(:pet2, user: user) }

  describe "validation" do
    it "全て入力済みであればバリデーションエラーは発生しないこと" do
      expect(pet2).to be_valid
    end

    it "imageを選択していない場合エラーは発生しないこと" do
      expect(pet1).to be_valid
    end

    it "ageを入力していない場合はエラーが発生すること" do
      pet2.age = ""
      expect(pet2).to be_invalid
    end

    it "genderを入力していない場合はエラーが発生すること" do
      pet2.gender = ""
      expect(pet2).to be_invalid
    end

    it "characterを入力していない場合はエラーが発生しないこと" do
      pet2.character = ""
      expect(pet2).to be_valid
    end

    it "characterの文字数が５０字以上の場合はエラーが発生すること" do
      pet2.character = "a" * 51
      expect(pet2).to be_invalid
    end
  end
end
