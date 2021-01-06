require 'rails_helper'

RSpec.describe 'Notifications', type: :system do
  let!(:user)          { create(:user) }
  let!(:user2)         { create(:user2) }
  let!(:protector)     { create(:protector) }
  let!(:protector2)    { create(:protector2) }
  let!(:room)          { create(:room) }
  let!(:entry)         { create(:entry, user: user, protector: protector, room: room) }
  let!(:message)       { create(:message, user: user, protector: protector, room: room) }
  let!(:notification1) { protector.active_notifications.create(visited_user: user, room: room, message: message, action: 'dm') }
  let!(:dog)           { create(:dog2, protector: protector) }
  let!(:notification2) { user.active_notifications.create(visited_protector: protector, dog: dog, action: 'like') }
  let!(:notification3) { user.active_notifications.create(visited_protector: protector, action: 'follow') }
  let!(:notification4) { user.active_notifications.create(visited_protector: protector, room: room, message: message, action: 'dm') }

  describe "get_index" do
    context "notificationが存在するuserがサインインしている場合" do
      before do
        visit new_user_session_path
        fill_in 'Eメールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'testpassword'
        click_button 'ログイン'
        visit notifications_path
      end

      it "お知らせ内容が表示されること" do
        expect(page).to have_content notification1.visitor_protector.name
        expect(page).to have_content "メッセージが届いています"
      end

      it "visitor_protector.nameをクリックするとprotector詳細画面へ遷移すること" do
        click_on notification1.visitor_protector.name
        expect(current_path).to eq protector_path(protector)
      end

      it "メッセージをクリックするとroom画面へ遷移すること" do
        within '.notifications' do
          click_on 'メッセージ'
        end
        expect(current_path).to eq room_path(room)
      end
    end

    context "notificationが存在しないuserがサインインしている場合" do
      before do
        visit new_user_session_path
        fill_in 'Eメールアドレス', with: 'test2@example.com'
        fill_in 'パスワード', with: 'test2password'
        click_button 'ログイン'
        visit notifications_path
      end

      it "お知らせがない旨が表示されること" do
        expect(page).to have_content "お知らせはありません"
      end
    end

    context "notificationが存在するprotectorがサインインしている場合" do
      before do
        visit new_protector_session_path
        fill_in 'Eメールアドレス', with: 'protector@example.com'
        fill_in 'パスワード', with: 'testpassword'
        click_button 'ログイン'
        visit notifications_path
      end

      it "お知らせ内容が表示されること" do
        expect(page).to have_content notification2.visitor_user.name
        expect(page).to have_content "メッセージが届いています"
        expect(page).to have_content notification3.visitor_user.name
        expect(page).to have_content "保護犬をお気に入りに登録しました"
        expect(page).to have_content notification4.visitor_user.name
        expect(page).to have_content "あなたをフォローしました"
      end

      it "visitor_user.nameをクリックするとprotector詳細画面へ遷移すること" do
        click_on notification2.visitor_user.name, :match => :first
        expect(current_path).to eq user_path(user)
      end

      it "保護犬をクリックすると保護犬詳細画面へ遷移すること" do
        click_on '保護犬'
        expect(current_path).to eq dog_path(dog)
      end

      it "メッセージをクリックするとroom画面へ遷移すること" do
        within '.notifications' do
          click_on 'メッセージ'
        end
        expect(current_path).to eq room_path(room)
      end
    end

    context "notificationが存在しないprotectorがサインインしている場合" do
      before do
        visit new_protector_session_path
        fill_in 'Eメールアドレス', with: 'protector2@example.com'
        fill_in 'パスワード', with: 'test2password'
        click_button 'ログイン'
        visit notifications_path
      end

      it "お知らせがない旨が表示されること" do
        expect(page).to have_content "お知らせはありません"
      end
    end
  end
end
