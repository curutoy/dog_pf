require 'rails_helper'

RSpec.describe Notification, type: :model do
  let!(:user)          { create(:user) }
  let!(:protector)     { create(:protector) }
  let!(:room)          { create(:room) }
  let!(:message)       { create(:message, user: user, protector: protector, room: room) }
  let(:notification1)  { user.active_notifications.build(visited_protector: protector, room: room, message: message, action: 'dm') }
  let!(:dog)           { create(:dog2, protector: protector) }
  let(:notification2)  { user.active_notifications.build(visited_protector: protector, dog: dog, action: 'like') }
  let(:notification3)  { user.active_notifications.build(visited_protector: protector, action: 'follow') }

  describe "validate" do
    it "messageを作成する際にnotificationにエラーが生じないこと" do
      expect(notification1).to be_valid
    end

    it "お気に入り登録をする際のnotificationにエラーが生じないこと" do
      expect(notification2).to be_valid
    end

    it "フォローする際のnotificationにエラーが生じないこと" do
      expect(notification3).to be_valid
    end
  end
end
