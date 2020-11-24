require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:testuser1) { FactoryBot.build(:user) }
  let(:testuser2) { FactoryBot.build(:user2) }

  describe "sign_up" do
    before do
      visit new_user_registration_path
    end

    context "フォームの入力値が正常な場合" do
      it "userの新規作成が成功すること" do
        fill_in 'ユーザー名', with: 'testuser'
        fill_in 'Eメールアドレス', with: 'test@example.com'
        fill_in '自己紹介', with: 'test'
        select '東京都', from: '居住地'
        select '１人', from: '同居家族人数（ご自身含め）'
        select '一戸建て', from: '居住形態'
        select '無', from: 'お留守番時間（保護犬を迎える場合）'
        fill_in 'パスワード', with: 'testpassword'
        fill_in 'パスワード（確認用）', with: 'testpassword'
        click_button '登録'
        expect(current_path).to eq root_path
        expect(page).to have_content "アカウント登録が完了しました。"
      end
    end

    context "フォーム入力に誤りのある場合" do
      it "必須項目が未入力の際はエラーとなること" do
        fill_in 'ユーザー名', with: ''
        fill_in 'Eメールアドレス', with: 'test@example.com'
        fill_in '自己紹介', with: 'test'
        select '東京都', from: '居住地'
        select '１人', from: '同居家族人数（ご自身含め）'
        select '一戸建て', from: '居住形態'
        select '無', from: 'お留守番時間（保護犬を迎える場合）'
        fill_in 'パスワード', with: 'testpassword'
        fill_in 'パスワード（確認用）', with: 'testpassword'
        click_button '登録'
        expect(page).to have_content "エラーが発生しました"
        expect(page).to have_content "名前 が入力されていません。"
      end

      it "長さに上限のある項目が上限を超えてしまうとエラーとなること" do
        fill_in 'ユーザー名', with: 'a' * 21
        fill_in 'Eメールアドレス', with: 'test@example.com'
        fill_in '自己紹介', with: 'test'
        select '東京都', from: '居住地'
        select '１人', from: '同居家族人数（ご自身含め）'
        select '一戸建て', from: '居住形態'
        select '無', from: 'お留守番時間（保護犬を迎える場合）'
        fill_in 'パスワード', with: 'testpassword'
        fill_in 'パスワード（確認用）', with: 'testpassword'
        click_button '登録'
        expect(page).to have_content "エラーが発生しました"
        expect(page).to have_content "名前 は20文字以下に設定して下さい。"
      end

      it "長さに下限のある項目が下限に達しないとエラーとなること" do
        fill_in 'ユーザー名', with: 'testuser'
        fill_in 'Eメールアドレス', with: 'test@example.com'
        fill_in '自己紹介', with: 'test'
        select '東京都', from: '居住地'
        select '１人', from: '同居家族人数（ご自身含め）'
        select '一戸建て', from: '居住形態'
        select '無', from: 'お留守番時間（保護犬を迎える場合）'
        fill_in 'パスワード', with: 't' * 5
        fill_in 'パスワード（確認用）', with: 't' * 5
        click_button '登録'
        expect(page).to have_content "エラーが発生しました"
        expect(page).to have_content "パスワード は6文字以上に設定して下さい。"
      end

      it "一意であるべき項目が一意でないとエラーとなること" do
        testuser2.save
        fill_in 'ユーザー名', with: 'testuser'
        fill_in 'Eメールアドレス', with: 'test2@example.com'
        fill_in '自己紹介', with: 'test'
        select '東京都', from: '居住地'
        select '１人', from: '同居家族人数（ご自身含め）'
        select '一戸建て', from: '居住形態'
        select '無', from: 'お留守番時間（保護犬を迎える場合）'
        fill_in 'パスワード', with: 'testpassword'
        fill_in 'パスワード（確認用）', with: 'testpassword'
        click_button '登録'
        expect(page).to have_content "エラーが発生しました"
        expect(page).to have_content "メールアドレス は既に使用されています。"
      end

      it "パスワード入力が一致しないとエラーとなること" do
        fill_in 'ユーザー名', with: 'testuser'
        fill_in 'Eメールアドレス', with: 'test2@example.com'
        fill_in '自己紹介', with: 'test'
        select '東京都', from: '居住地'
        select '１人', from: '同居家族人数（ご自身含め）'
        select '一戸建て', from: '居住形態'
        select '無', from: 'お留守番時間（保護犬を迎える場合）'
        fill_in 'パスワード', with: 'testpassword'
        fill_in 'パスワード（確認用）', with: 'testpassword2'
        click_button '登録'
        expect(page).to have_content "エラーが発生しました"
        expect(page).to have_content "確認用パスワード とパスワードが一致しません。"
      end
    end

    context "既に登録済みの場合" do
      it "ログインリンクをクリックするとサインインページへ遷移すること" do
        click_link 'ログインする'
        expect(current_path).to eq new_user_session_path
      end
    end
  end

  describe "sign_in" do
    before do
      testuser1.save
      visit new_user_session_path
    end

    context "入力した情報に誤りがない場合" do
      it "ログインが正常に行われること" do
        fill_in 'Eメールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'testpassword'
        click_button 'ログイン'
        expect(page).to have_content "ログインしました。"
        expect(current_path).to eq root_path
      end
    end

    context "入力に誤りがある場合" do
      it "入力漏れがある場合エラーとなること" do
        fill_in 'Eメールアドレス', with: ''
        fill_in 'パスワード', with: 'testpassword'
        click_button 'ログイン'
        expect(page).to have_content "メールアドレスまたはパスワードが違います。"
      end

      it "入力が情報と一致しないとエラーとなること" do
        fill_in 'Eメールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'test2password'
        click_button 'ログイン'
        expect(page).to have_content "メールアドレスまたはパスワードが違います。"
      end
    end

    context "user情報が未登録の場合" do
      it "登録リンクをクリックするとサインアップページへ遷移すること" do
        click_link '登録する'
        expect(current_path).to eq new_user_registration_path
      end
    end
  end
end
