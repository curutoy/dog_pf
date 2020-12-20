require 'rails_helper'

RSpec.describe 'Rooms', type: :system do
  let!(:user)      { create(:user) }
  let!(:protector) { create(:protector) }
  let(:room)       { build(:room) }
  let(:entry)      { build(:entry, user: user, protector: protector) }
  let(:message)    { build(:message, user: user, protector: protector) }

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

  describe "get_index" do
    context "userがログインしている場合" do
      before do
        visit new_user_session_path
        fill_in 'Eメールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'testpassword'
        click_button 'ログイン'
        room.save
        entry.room_id = room.id
        entry.save
        visit rooms_path
      end

      it "メッセージ相手の情報が表示されていること" do
        expect(page).to have_content protector.name
      end

      it "メッセージ相手の画像をクリックするとトーク詳細画面へ遷移すること" do
        find('.room-partner-img').click
        expect(current_path).to eq room_path(room.id)
      end
    end

    context "protectorがログインしている場合" do
      before do
        visit new_protector_session_path
        fill_in 'Eメールアドレス', with: 'protector@example.com'
        fill_in 'パスワード', with: 'testpassword'
        click_button 'ログイン'
        room.save
        entry.room_id = room.id
        entry.save
        visit rooms_path
      end

      it "メッセージ相手の情報が表示されていること" do
        expect(page).to have_content user.name
      end

      it "メッセージ相手の画像をクリックするとトーク詳細画面へ遷移すること" do
        find('.room-partner-img').click
        expect(current_path).to eq room_path(room.id)
      end
    end
  end

  describe "get_show" do
    context "userがログインしている場合" do
      before do
        visit new_user_session_path
        fill_in 'Eメールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'testpassword'
        click_button 'ログイン'
        room.save
        entry.room_id = room.id
        entry.save
        visit room_path(room.id)
      end

      it "userとprotecotrの表示があること" do
        expect(page).to have_content user.name
        expect(page).to have_content protector.name
      end

      it "user情報をクリックするとuser詳細画面へ遷移すること" do
        find('.m-user').click
        expect(current_path).to eq user_path(user.id)
      end

      it "protector情報をクリックするとprotector詳細画面へ遷移すること" do
        find('.m-protector').click
        expect(current_path).to eq protector_path(protector.id)
      end

      it "メッセージが存在しない場合はテキストが表示されること" do
        expect(page).to have_content "メッセージはまだありません"
      end

      it "メッセーが存在している場合はメッセージ内容が表示されること" do
        message.room_id = room.id
        message.save
        visit room_path(room.id)
        expect(page).to have_content message.content
      end
    end

    context "protectorがログインしている場合" do
      before do
        visit new_protector_session_path
        fill_in 'Eメールアドレス', with: 'protector@example.com'
        fill_in 'パスワード', with: 'testpassword'
        click_button 'ログイン'
        room.save
        entry.room_id = room.id
        entry.save
        visit room_path(room.id)
      end

      it "userとprotecotrの表示があること" do
        expect(page).to have_content user.name
        expect(page).to have_content protector.name
      end

      it "user情報をクリックするとuser詳細画面へ遷移すること" do
        find('.m-user').click
        expect(current_path).to eq user_path(user.id)
      end

      it "protector情報をクリックするとprotector詳細画面へ遷移すること" do
        find('.m-protector').click
        expect(current_path).to eq protector_path(protector.id)
      end

      it "メッセージが存在しない場合はテキストが表示されること" do
        expect(page).to have_content "メッセージはまだありません"
      end

      it "メッセーが存在している場合はメッセージ内容が表示されること" do
        message.room_id = room.id
        message.save
        visit room_path(room.id)
        expect(page).to have_content message.content
      end
    end
  end
end
