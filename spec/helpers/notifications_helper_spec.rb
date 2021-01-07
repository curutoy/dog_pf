require 'rails_helper'

RSpec.describe NotificationsHelper, type: :helper do
  include NotificationsHelper
  include Devise::TestHelpers

  let!(:user)          { create(:user) }
  let!(:protector)     { create(:protector) }
  let!(:room)          { create(:room) }
  let!(:entry)         { create(:entry, user: user, protector: protector, room: room) }
  let!(:message)       { create(:message, user: user, protector: protector, room: room) }
  let!(:dog)           { create(:dog2, protector: protector) }
  let(:notification1) { user.active_notifications.create(visited_protector: protector, action: 'follow') }
  let(:notification2) { user.active_notifications.create(visited_protector: protector, dog: dog, action: 'like') }
  let(:notification3) { user.active_notifications.create(visited_protector: protector, room: room, message: message, action: 'dm') }

  describe "notification_form" do
    context "protectorがサインインしている場合" do
      before do
        sign_in protector
      end

      it "actionがfollowの際はフォローした旨の内容が表示されること" do
        expect(notification_form(notification1)).to include 'あなたをフォローしました'
      end

      it "actionがlikeの場合はお気に入り登録された旨の内容が表示されること" do
        expect(notification_form(notification2)).to include 'お気に入りに登録しました'
      end

      it "actionがdmの場合にはメッセージが送信された旨の内容が表示されること" do
        expect(notification_form(notification3)).to include 'が届いています'
      end
    end

    context "userがサインインしている場合" do
      before do
        sign_in user
      end

      it "actionがdmの場合にはメッセージが送信された旨の内容が表示されること" do
        expect(notification_form(notification3)).to include 'が届いています'
      end
    end
  end
end
