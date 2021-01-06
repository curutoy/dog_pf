require 'rails_helper'

RSpec.describe 'Messages', type: :system do
  let!(:user)      { create(:user) }
  let!(:protector) { create(:protector) }
  let!(:room)      { create(:room) }
  let!(:entry)     { create(:entry, user: user, protector: protector, room: room) }
  let(:message)    { build(:message, user: user, protector: protector) }

  describe "post_create" do
    context "userがログインしている場合" do
      before do
        visit new_user_session_path
        fill_in 'Eメールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'testpassword'
        click_button 'ログイン'
        visit room_path(room.id)
      end

      it "メッセージを入力して送信した場合送信が成功すること" do
        fill_in 'message-content', with: 'test message'
        click_on '送信'
        expect(page).to have_content "test message"
      end

      it "メッセージを入力せずに送信した場合送信が失敗すること" do
        click_on '送信'
        expect(current_path).to eq room_path(room.id)
        expect(page).to have_content "メッセージ送信に失敗しました"
      end

      it "メッセージを入力して送信した場合、notificationが登録されること" do
        expect do
          fill_in 'message-content', with: 'test message'
          click_on '送信'
          visit current_path
        end.to change(Notification, :count).by(1)
      end
    end

    context "protectorがログインしている場合" do
      before do
        visit new_protector_session_path
        fill_in 'Eメールアドレス', with: 'protector@example.com'
        fill_in 'パスワード', with: 'testpassword'
        click_button 'ログイン'
        visit room_path(room.id)
      end

      it "メッセージを入力して送信した場合送信が成功すること" do
        fill_in 'message-content', with: 'test message'
        click_on '送信'
        expect(page).to have_content "test message"
      end

      it "メッセージを入力せずに送信した場合送信が失敗すること" do
        click_on '送信'
        expect(current_path).to eq room_path(room.id)
        expect(page).to have_content "メッセージ送信に失敗しました"
      end

      it "メッセージを入力して送信した場合、notificationが登録されること" do
        expect do
          fill_in 'message-content', with: 'test message'
          click_on '送信'
          visit current_path
        end.to change(Notification, :count).by(1)
      end
    end
  end
end
