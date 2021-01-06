require 'rails_helper'

RSpec.describe 'Relationships', type: :system do
  let!(:user)      { create(:user) }
  let!(:protector) { create(:protector) }
  let!(:dog)       { create(:dog2, protector: protector) }
  let(:favorite)   { build(:favorite, user: user, dog: dog) }

  describe "post_create" do
    before do
      visit new_user_session_path
      fill_in 'Eメールアドレス', with: 'test@example.com'
      fill_in 'パスワード', with: 'testpassword'
      click_button 'ログイン'
      visit dog_path(dog.id)
    end

    it "お気に入り登録をしていないdogの場合登録を行えること", js: true do
      expect do
        click_button 'お気に入り登録'
        sleep 1
      end.to change(Favorite, :count).by(1)
    end

    it "お気に入り登録ボタンをクリックすると、お気に入り数が１増えること", js: true do
      click_button 'お気に入り登録'
      sleep 1
      expect(page).to have_content "1"
    end

    it "お気に入り登録ボタンをクリックすると、ボタンがお気に入り登録済みとなること", js: true do
      click_button 'お気に入り登録'
      sleep 1
      expect(page).to have_button "お気に入り登録済み"
    end

    it "お気に入り登録を行うと、notificationも登録されること" do
      expect do
        click_button 'お気に入り登録'
        visit current_path
      end.to change(Notification, :count).by(1)
    end
  end

  describe "get_index" do
    before do
      favorite.save
      visit new_user_session_path
      fill_in 'Eメールアドレス', with: 'test@example.com'
      fill_in 'パスワード', with: 'testpassword'
      click_button 'ログイン'
      visit user_favorites_path(user_id: user.id)
    end

    it "お気に入り数とdog情報が確認できること" do
      expect(page).to have_content "お気に入り（1）"
      expect(page).to have_content dog.name
      expect(page).to have_content dog.address
      expect(page).to have_content dog.gender
    end

    it "dogの画像をクリックするとdog詳細画面へ遷移すること" do
      find('.dog-like-img').click
      expect(current_path).to eq dog_path(dog)
    end
  end

  describe "post_delete" do
    before do
      favorite.save
      visit new_user_session_path
      fill_in 'Eメールアドレス', with: 'test@example.com'
      fill_in 'パスワード', with: 'testpassword'
      click_button 'ログイン'
      visit dog_path(dog.id)
    end

    it "お気に入り登録ずみのdogページ場合登録解除を行えること", js: true do
      expect do
        click_button 'お気に入り登録済み'
        sleep 1
      end.to change(Favorite, :count).by(-1)
    end

    it "お気に入り登録済みボタンをクリックすると、お気に入り数が１減ること", js: true do
      click_button 'お気に入り登録済み'
      sleep 1
      expect(page).to have_content "0"
    end

    it "お気に入り登録済みボタンをクリックすると、ボタンがお気に入り登録となること", js: true do
      click_button 'お気に入り登録済み'
      sleep 1
      expect(page).to have_button "お気に入り登録"
    end
  end
end
