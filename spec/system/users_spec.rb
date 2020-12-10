require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:testuser1) { build(:user) }
  let(:testuser2) { build(:user2) }
  let(:testuser3) { build(:user3) }
  let(:pet1)      { build(:pet2, user: testuser1) }
  let(:pet2)      { build(:pet2, user: testuser2) }

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
        expect(page).to have_content "ユーザー名 が入力されていません。"
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
        expect(page).to have_content "ユーザー名 は20文字以下に設定して下さい。"
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

  describe "edit" do
    before do
      testuser1.save
      visit new_user_session_path
      fill_in 'Eメールアドレス', with: 'test@example.com'
      fill_in 'パスワード', with: 'testpassword'
      click_button 'ログイン'
      visit edit_user_registration_path
    end

    context "入力した内容に誤りがない場合" do
      it "情報の更新が正常に行えること" do
        fill_in 'ユーザー名', with: 'change_name'
        fill_in '現在のパスワード', with: 'testpassword'
        click_button '更新'
        expect(current_path).to eq user_path testuser1
      end

      it "必須項目が未入力の場合はエラーとなること" do
        fill_in 'ユーザー名', with: ''
        fill_in '現在のパスワード', with: 'testpassword'
        click_button '更新'
        expect(page).to have_content "ユーザー名 が入力されていません。"
      end

      it "長さに上限のある項目が上限を超えてしまうとエラーとなること" do
        fill_in 'ユーザー名', with: 'a' * 21
        fill_in '現在のパスワード', with: 'testpassword'
        click_button '更新'
        expect(page).to have_content "ユーザー名 は20文字以下に設定して下さい。"
      end

      it "長さに下限のある項目が上限を超えてしまうとエラーとなること" do
        fill_in '新パスワード', with: 'a' * 5
        fill_in '現在のパスワード', with: 'testpassword'
        click_button '更新'
        expect(page).to have_content "パスワード は6文字以上に設定して下さい。"
      end

      it "一意であるべき項目が一意でないとエラーとなること" do
        testuser2.save
        fill_in 'Eメールアドレス', with: 'test2@example.com'
        fill_in '現在のパスワード', with: 'testpassword'
        click_button '更新'
        expect(page).to have_content "メールアドレス は既に使用されています。"
      end

      it "パスワード入力が一致しないとエラーとなること" do
        fill_in '新パスワード', with: 'changepassword'
        fill_in '新パスワード（確認用）', with: 'changepassword2'
        fill_in '現在のパスワード', with: 'testpassword'
        click_button '更新'
        expect(page).to have_content "確認用パスワード とパスワードが一致しません。"
      end

      it "現在のパスワードが未入力の場合はエラーとなること" do
        fill_in 'ユーザー名', with: 'change_name'
        click_button '更新'
        expect(page).to have_content "現在のパスワード が入力されていません。"
      end

      it "現在のパスワードに誤りがある場合はエラーとなること" do
        fill_in 'ユーザー名', with: 'change_name'
        fill_in '現在のパスワード', with: 'password'
        click_button '更新'
        expect(page).to have_content "現在のパスワード が間違っています。"
      end
    end
  end

  describe "show" do
    context "userがサインインした場合", js: true do
      before do
        testuser1.save
        testuser2.save
        testuser3.save
        visit new_user_session_path
        fill_in 'Eメールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'testpassword'
        click_button 'ログイン'
        pet1.save
        pet2.save
      end

      context "マイページにアクセスした場合" do
        before do
          visit user_path(testuser1)
        end

        it "アクセスができること" do
          expect(current_path).to eq user_path(testuser1)
        end

        it "登録した内容が反映されていること" do
          expect(page).to have_content "testuser"
          expect(page).to have_content "東京都"
          expect(page).to have_content "１人"
          expect(page).to have_content "一戸建て"
          expect(page).to have_content "test"
        end

        it "編集リンクが表示されていること" do
          expect(page).to have_link "編集"
        end

        it "先住犬を投稿できるアイコンから新規登録モーダルが表示できること" do
          find('.pet-new-icon').click
          sleep 3
          expect(page).to have_content "写真"
          expect(page).to have_content "年齢"
          expect(page).to have_content "性別"
          expect(page).to have_content "性格（50文字以内)"
        end

        it "登録済みの先住動物欄にeditがありモーダル表示ができること" do
          page.evaluate_script('$(".fade").removeClass("fade")')
          find('.pet-edit-icon').click
          sleep 3
          expect(page).to have_content "写真"
          expect(page).to have_content "年齢"
          expect(page).to have_content "性別"
          expect(page).to have_content "性格（50文字以内)"
        end

        it "登録済みの先住動物欄にdeleteのアイコンが表示されていること" do
          expect(page).to have_css '.pet-delete-icon'
        end
      end

      context "他のユーザーのページにアクセスした場合" do
        before do
          visit user_path(testuser2)
        end

        it "アクセスができること" do
          expect(current_path).to eq user_path(testuser2)
        end

        it "編集リンクが表示されていないこと" do
          expect(page).to have_no_link "編集"
        end

        it "先住動物を登録するアイコンが表示されていないこと" do
          expect(page).to have_no_css '.pet-new-icon'
        end

        it "先住動物を編集するアイコンが表示されていないこと" do
          expect(page).to have_no_css '.pet-edit-icon'
        end

        it "先住動物を削除するアイコンが表示されていないこと" do
          expect(page).to have_no_css '.pet-delete-icon'
        end
      end

      context "先住犬を登録していないページにアクセスした場合" do
        before do
          visit user_path(testuser3)
        end

        it "先住動物が存在しない旨の文が表示されること" do
          expect(page).to have_content "先住動物はいません。"
        end
      end
    end
  end
end
