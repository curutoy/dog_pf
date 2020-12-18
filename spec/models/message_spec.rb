require 'rails_helper'

RSpec.describe Message, type: :model do
  let!(:user)      { create(:user) }
  let!(:protector) { create(:protector) }
  let!(:room)      { create(:room) }
  let(:message) { build(:message, user: user, protector: protector, room: room) }

  describe "validate" do
    it "全ての値が存在する場合はエラーが発生しないこと" do
      expect(message).to be_valid
    end

    it "user_idが存在しない場合はエラーが発生しないこと" do
      message.user_id = nil
      expect(message).to be_valid
    end

    it "protector_idが存在しない場合はエラーが発生しないこと" do
      message.protector_id = nil
      expect(message).to be_valid
    end

    it "room_idが存在しない場合はエラーとなること" do
      message.room_id = nil
      expect(message).to be_invalid
    end

    it "contentが存在しない場合はエラーとなること" do
      message.content = ""
      expect(message).to be_invalid
    end

    it "contentが100文字以上の場合はエラーとなること" do
      message.content = "a" * 101
      expect(message).to be_invalid
    end
  end
end
