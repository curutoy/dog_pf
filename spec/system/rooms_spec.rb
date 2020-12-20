require 'rails_helper'

RSpec.describe 'Rooms', type: :system do
  let!(:user)      { create(:user) }
  let!(:protector) { create(:protector) }
  let!(:room)      { build(:room) }
  let!(:entry)     { build(:entry, user: user, protector: protector) }

  describe "post_create" do
    context "userがログインしている場合" do
      before do
        visit new_user_session_path
        fill_in 'Eメールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'testpassword'
        click_button 'ログイン'
        visit protector_path(protector.id)
      end

      context "メッセージルームを未作成の相手だった場合" do
        it "メッセージを送るボタンが表示されていること" do
          expect(page).to have_button "メッセージを送る"
        end

        it "メッセージを送るボタンをクリックするとトークルームが作成されること" do
          expect do
            click_on "メッセージを送る"
          end.to change(Room, :count).by(1)
        end

        it "トークルーム作成後はトークルームへ遷移すること" do
          click_on "メッセージを送る"
          expect(current_path).to eq room_path(Room.last.id)
        end
      end

      context "メッセージルームを作成済みの相手だった場合" do
        before do
          room.save
          entry.room_id = room.id
          entry.save
          visit protector_path(protector.id)
        end

        it "メッセージ画面へのリンクが表示されていること" do
          expect(page).to have_content "メッセージ画面へ"
        end

        it "メッセージ画面へをクリックするとトークルームへ遷移すること" do
          click_on "メッセージ画面へ"
          expect(current_path).to eq room_path(room.id)
        end
      end
    end

    context "protectorがログインしている場合" do
      before do
        visit new_protector_session_path
        fill_in 'Eメールアドレス', with: 'protector@example.com'
        fill_in 'パスワード', with: 'testpassword'
        click_button 'ログイン'
        visit user_path(user.id)
      end

      context "メッセージルームを未作成の相手だった場合" do
        it "メッセージを送るボタンが表示されていること" do
          expect(page).to have_button "メッセージを送る"
        end

        it "メッセージを送るボタンをクリックするとトークルームが作成されること" do
          expect do
            click_on "メッセージを送る"
          end.to change(Room, :count).by(1)
        end

        it "トークルーム作成後はトークルームへ遷移すること" do
          click_on "メッセージを送る"
          expect(current_path).to eq room_path(Room.last.id)
        end
      end

      context "メッセージルームを作成済みの相手だった場合" do
        before do
          room.save
          entry.room_id = room.id
          entry.save
          visit user_path(user.id)
        end

        it "メッセージ画面へのリンクが表示されていること" do
          expect(page).to have_content "メッセージ画面へ"
        end

        it "メッセージ画面へをクリックするとトークルームへ遷移すること" do
          click_on "メッセージ画面へ"
          expect(current_path).to eq room_path(room.id)
        end
      end
    end
  end
end
