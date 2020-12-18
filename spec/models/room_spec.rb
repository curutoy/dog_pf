require 'rails_helper'

RSpec.describe Room, type: :model do
  let(:room) { build(:room) }

  describe "validate" do
    it "全て入力済みの際にエラーが発生しないこと" do
      expect(room).to be_valid
    end

    it "nameがnilの際もエラーが発生しないこと" do
      room.name = nil
      expect(room).to be_valid
    end
  end
end
