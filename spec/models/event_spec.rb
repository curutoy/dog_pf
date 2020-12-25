require 'rails_helper'

RSpec.describe Event, type: :model do
  let!(:protector) { create(:protector) }
  let(:event)      { build(:event, protector: protector) }

  describe "validation" do
    it "全て入力済みであればバリデーションエラーは発生しないこと" do
      expect(event).to be_valid
    end

    it "due_onが空の場合エラーが発生すること" do
      event.due_on = ""
      expect(event).to be_invalid
    end

    it "start_atが空白の場合エラーが発生すること" do
      event.start_at = ""
      expect(event).to be_invalid
    end

    it "finish_atが空白の場合エラーが発生すること" do
      event.finish_at = ""
      expect(event).to be_invalid
    end

    it "addressが空白の場合エラーが発生すること" do
      event.address = ""
      expect(event).to be_invalid
    end

    it "contentが200文字以上の場合エラーが発生すること" do
      event.content = "a" * 201
      expect(event).to be_invalid
    end
  end
end
