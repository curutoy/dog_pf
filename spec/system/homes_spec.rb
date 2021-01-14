require 'rails_helper'

RSpec.describe 'Homes', type: :system do
  let!(:user)       { create(:user) }
  let!(:protector)  { create(:protector) }

  describe "home_index" do
    context "ログインしていない場合" do
      before do
        visit homes_path
      end

      it "アクセスができること" do
        expect(current_path).to eq homes_path
      end

      it "里親希望者のサインアップページへのリンクをクリックすると遷移すること" do
        find('.home-login-u').click
        expect(current_path).to eq new_user_registration_path
      end

      it "保護活動家のサインアップページへのリンクをクリックすると遷移すること" do
        find('.home-login-p').click
        expect(current_path).to eq new_protector_registration_path
      end
    end

    context "protectorがサインインした場合" do
      before do
        visit new_protector_session_path
        fill_in 'Eメールアドレス', with: 'protector@example.com'
        fill_in 'パスワード', with: 'testpassword'
        click_button 'ログイン'
        visit homes_path
      end

      it "アクセスができること" do
        expect(current_path).to eq homes_path
      end

      it "里親希望者のリンクが存在しないこと" do
        expect(page).to have_no_css '.home-login-u'
      end

      it "保護活動家のリンクが存在しないこと" do
        expect(page).to have_no_css '.home-login-p'
      end
    end

    context "userがサインインした場合" do
      before do
        visit new_user_session_path
        fill_in 'Eメールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'testpassword'
        click_button 'ログイン'
        visit homes_path
      end

      it "アクセスができること" do
        expect(current_path).to eq homes_path
      end

      it "里親希望者のリンクが存在しないこと" do
        expect(page).to have_no_css '.home-login-u'
      end

      it "保護活動家のリンクが存在しないこと" do
        expect(page).to have_no_css '.home-login-p'
      end
    end
  end
end
