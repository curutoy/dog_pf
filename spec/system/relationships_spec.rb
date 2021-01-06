require 'rails_helper'

RSpec.describe 'Relationships', type: :system do
  let!(:protector)    { create(:protector) }
  let!(:user)         { create(:user) }
  let(:relationship)  { build(:relationship, protector: protector, user: user) }

  describe "post_create" do
    before do
      visit new_user_session_path
      fill_in 'Eメールアドレス', with: 'test@example.com'
      fill_in 'パスワード', with: 'testpassword'
      click_button 'ログイン'
      visit protector_path(protector.id)
    end

    it "フォローしていないprotectorの場合フォローを行えること", js: true do
      expect do
        click_button 'フォローする'
        sleep 1
      end.to change(Relationship, :count).by(1)
    end

    it "フォローするボタンをクリックすると、フォロワー数が１増えること", js: true do
      click_button 'フォローする'
      sleep 1
      expect(page).to have_content "フォロワー1人"
    end

    it "userページのフォロー人数が１増えること" do
      click_button 'フォローする'
      visit user_path(user.id)
      expect(page).to have_content "フォロー1人"
    end

    it "フォローを行うとnotificationも登録されること", js: true do
      expect do
        click_button 'フォローする'
        visit current_path
      end.to change(Notification, :count).by(1)
    end
  end

  describe "post_delete" do
    before do
      relationship.save
      visit new_user_session_path
      fill_in 'Eメールアドレス', with: 'test@example.com'
      fill_in 'パスワード', with: 'testpassword'
      click_button 'ログイン'
      visit protector_path(protector.id)
    end

    it "フォローしているprotectorの場合フォロー解除を行えること", js: true do
      expect do
        click_button 'フォロー中'
        sleep 1
      end.to change(Relationship, :count).by(-1)
    end

    it "フォロー中ボタンをクリックすると、フォロワー数が１減ること", js: true do
      click_button 'フォロー中'
      sleep 1
      expect(page).to have_content "フォロワー0人"
    end

    it "userページのフォロー人数が１減ること" do
      click_button 'フォロー中'
      visit user_path(user.id)
      expect(page).to have_content "フォロー0人"
    end
  end
end
