require 'rails_helper'

RSpec.describe Entry, type: :model do
  let!(:user)      { create(:user) }
  let!(:protector) { create(:protector) }
  let!(:room)      { create(:room) }
  let!(:entry)     { build(:entry, user: user, protector: protector, room: room) }
  let!(:entry2)    { build(:entry, user: user, protector: protector, room: room) }

  describe "validate" do
    it "全て値が存在する場合はエラーが発生しないこと" do
      expect(entry).to be_valid
    end

    it "user_idが存在しない場合はエラーとなること" do
      entry.user_id = nil
      expect(entry).to be_invalid
    end

    it "protector_idが存在しない場合はエラーとなること" do
      entry.protector_id = nil
      expect(entry).to be_invalid
    end

    it "room_idが存在しない場合はエラーとなること" do
      entry.room_id = nil
      expect(entry).to be_invalid
    end

    it "user_idとdog_idがuniqueでない場合はエラーとなること" do
      entry2.save
      expect(entry).to be_invalid
    end
  end
end
