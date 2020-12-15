require 'rails_helper'

RSpec.describe Favorite, type: :model do
  let!(:user)     { create(:user) }
  let!(:dog)      { create(:dog2) }
  let(:favorite)  { build(:favorite, user: user, dog: dog) }
  let(:favorite2) { build(:favorite, user: user, dog: dog) }

  describe "validation" do
    it "dog_idとuser_idが存在する際はエラーが発生しないこと" do
      expect(favorite).to be_valid
    end

    it "dog_idとuser_idのどちらかが存在しない場合はエラーとなること" do
      favorite.dog_id = ""
      expect(favorite).to be_invalid
    end

    it "dog_idとuser_idがuniqueでない場合はエラーとなること" do
      favorite.save
      expect(favorite2).to be_invalid
    end
  end
end
