require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let!(:protector)    { create(:protector) }
  let!(:user)         { create(:user) }
  let(:relationship)  { build(:relationship, protector: protector, user: user) }
  let(:relationship2) { build(:relationship, protector: protector, user: user) }

  describe "validation" do
    it "protector_idとuser_idが存在する際はエラーが発生しないこと" do
      expect(relationship).to be_valid
    end

    it "protector_idとuser_idのどちらかが存在しない場合はエラーとなること" do
      relationship.protector_id = ""
      expect(relationship).to be_invalid
    end

    it "protector_idとuser_idがuniqueでない場合はエラーとなること" do
      relationship.save
      expect(relationship2).to be_invalid
    end
  end
end
