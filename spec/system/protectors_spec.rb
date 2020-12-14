require 'rails_helper'

RSpec.describe 'Protectors', type: :system do
  let(:testprotector1) { FactoryBot.build(:protector) }
  let(:testprotector2) { FactoryBot.build(:protector2) }

  describe "sign_up" do
    before do
      visit new_protector_registration_path
    end

    context "フォームの入力値が正常な場合" do
      it "userの新規作成が成功すること" do
        fill_in '保護団体名', with: 'testprotector'
        fill_in 'Eメールアドレス', with: 'test@example.com'
        fill_in '紹介文', with: 'test'
        select '東京都', from: '所在地'
        fill_in 'パスワード', with: 'testpassword'
        fill_in 'パスワード（確認用）', with: 'testpassword'
        click_button '登録'
        expect(current_path).to eq root_path
        expect(page).to have_content "アカウント登録が完了しました。"
      end
    end

    context "フォーム入力に誤りのある場合" do
      it "必須項目が未入力の際はエラーとなること" do
        fill_in '保護団体名', with: ''
        fill_in 'Eメールアドレス', with: 'test@example.com'
        fill_in '紹介文', with: 'test'
        select '東京都', from: '所在地'
        fill_in 'パスワード', with: 'testpassword'
        fill_in 'パスワード（確認用）', with: 'testpassword'
        click_button '登録'
        expect(page).to have_content "エラーが発生しました"
        expect(page).to have_content "保護団体名 が入力されていません。"
      end

      it "長さに上限のある項目が上限を超えてしまうとエラーとなること" do
        fill_in '保護団体名', with: 'a' * 21
        fill_in 'Eメールアドレス', with: 'test@example.com'
        fill_in '紹介文', with: 'test'
        select '東京都', from: '所在地'
        fill_in 'パスワード', with: 'testpassword'
        fill_in 'パスワード（確認用）', with: 'testpassword'
        click_button '登録'
        expect(page).to have_content "エラーが発生しました"
        expect(page).to have_content "保護団体名 は20文字以下に設定して下さい。"
      end

      it "長さに下限のある項目が下限に達しないとエラーとなること" do
        fill_in '保護団体名', with: 'testprotector'
        fill_in 'Eメールアドレス', with: 'test@example.com'
        fill_in '紹介文', with: 'test'
        select '東京都', from: '所在地'
        fill_in 'パスワード', with: 't' * 5
        fill_in 'パスワード（確認用）', with: 't' * 5
        click_button '登録'
        expect(page).to have_content "エラーが発生しました"
        expect(page).to have_content "パスワード は6文字以上に設定して下さい。"
      end

      it "一意であるべき項目が一意でないとエラーとなること" do
        testprotector2.save
        fill_in '保護団体名', with: 'testprotector'
        fill_in 'Eメールアドレス', with: 'protector2@example.com'
        fill_in '紹介文', with: 'test'
        select '東京都', from: '所在地'
        fill_in 'パスワード', with: 'testpassword'
        fill_in 'パスワード（確認用）', with: 'testpassword'
        click_button '登録'
        expect(page).to have_content "エラーが発生しました"
        expect(page).to have_content "メールアドレス は既に使用されています。"
      end

      it "パスワード入力が一致しないとエラーとなること" do
        fill_in '保護団体名', with: 'testprotector'
        fill_in 'Eメールアドレス', with: 'test2@example.com'
        fill_in '紹介文', with: 'test'
        select '東京都', from: '所在地'
        fill_in 'パスワード', with: 'testpassword'
        fill_in 'パスワード（確認用）', with: 'testpassword2'
        click_button '登録'
        expect(page).to have_content "エラーが発生しました"
        expect(page).to have_content "確認用パスワード とパスワードが一致しません。"
      end
    end

    context "既に登録済みの場合" do
      it "ログインボタンをクリックするとサインインページへ遷移すること" do
        click_link 'ログインする'
        expect(current_path).to eq new_protector_session_path
      end
    end
  end

  describe "sign_in" do
    before do
      testprotector1.save
      visit new_protector_session_path
    end

    context "入力した情報に誤りがない場合" do
      it "ログインが正常に行われること" do
        fill_in 'Eメールアドレス', with: 'protector@example.com'
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
        fill_in 'Eメールアドレス', with: 'protector@example.com'
        fill_in 'パスワード', with: 'test2password'
        click_button 'ログイン'
        expect(page).to have_content "メールアドレスまたはパスワードが違います。"
      end
    end

    context "user情報が未登録の場合" do
      it "登録リンクをクリックするとサインアップページへ遷移すること" do
        click_link '登録する'
        expect(current_path).to eq new_protector_registration_path
      end
    end
  end

  describe "edit" do
    before do
      testprotector1.save
      visit new_protector_session_path
      fill_in 'Eメールアドレス', with: 'protector@example.com'
      fill_in 'パスワード', with: 'testpassword'
      click_button 'ログイン'
      visit edit_protector_registration_path
    end

    context "入力した内容に誤りがない場合" do
      it "情報の更新が正常に行えること" do
        fill_in '保護団体名', with: 'change_name'
        fill_in '現在のパスワード', with: 'testpassword'
        click_button '更新'
        expect(current_path).to eq protector_path testprotector1
      end

      it "必須項目が未入力の場合はエラーとなること" do
        fill_in '保護団体名', with: ''
        fill_in '現在のパスワード', with: 'testpassword'
        click_button '更新'
        expect(page).to have_content "保護団体名 が入力されていません。"
      end

      it "長さに上限のある項目が上限を超えてしまうとエラーとなること" do
        fill_in '保護団体名', with: 'a' * 21
        fill_in '現在のパスワード', with: 'testpassword'
        click_button '更新'
        expect(page).to have_content "保護団体名 は20文字以下に設定して下さい。"
      end

      it "長さに下限のある項目が上限を超えてしまうとエラーとなること" do
        fill_in '新パスワード', with: 'a' * 5
        fill_in '現在のパスワード', with: 'testpassword'
        click_button '更新'
        expect(page).to have_content "パスワード は6文字以上に設定して下さい。"
      end

      it "一意であるべき項目が一意でないとエラーとなること" do
        testprotector2.save
        fill_in 'Eメールアドレス', with: 'protector2@example.com'
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
        fill_in '保護団体名', with: 'change_name'
        click_button '更新'
        expect(page).to have_content "現在のパスワード が入力されていません。"
      end

      it "現在のパスワードに誤りがある場合はエラーとなること" do
        fill_in '保護団体名', with: 'change_name'
        fill_in '現在のパスワード', with: 'password'
        click_button '更新'
        expect(page).to have_content "現在のパスワード が間違っています。"
      end
    end
  end

  describe "show" do
    let!(:user)        { create(:user) }
    let(:relationship) { build(:relationship, protector: testprotector1, user: user) }
    let!(:dog)         { build(:dog2, protector: testprotector1) }

    before do
      testprotector1.save
    end

    context "protectorがサインインした場合", js: true do
      before do
        relationship.save
        dog.save
        visit new_protector_session_path
        fill_in 'Eメールアドレス', with: 'protector@example.com'
        fill_in 'パスワード', with: 'testpassword'
        click_button 'ログイン'
      end

      context "マイページにアクセスした場合" do
        before do
          visit protector_path(testprotector1)
        end

        it "アクセスができること" do
          expect(current_path).to eq protector_path(testprotector1)
        end

        it "登録した内容が反映されていること" do
          expect(page).to have_content "testprotector"
          expect(page).to have_content "東京都"
          expect(page).to have_content "test"
        end

        it "編集リンクが表示されていること" do
          expect(page).to have_link "編集"
        end

        it "フォローボタンは表示されていないこと" do
          expect(page).to have_no_css '.follow-btn'
        end

        it "フォロワー人数をクリックするとフォローしているuserがモーダル表示されること" do
          find('.follower-count').click
          sleep 3
          expect(page).to have_content user.name
        end

        it "登録済みのdogが表示されていること" do
          expect(page).to have_content dog.name
          expect(page).to have_content dog.age
          expect(page).to have_content dog.gender
        end

        it "登録済みの画像をクリックするとdog詳細画面へ遷移すること" do
          find('.protector-dog-img').click
          expect(current_path).to eq dog_path(dog)
        end
      end

      context "他のprotectorのページにアクセスした場合" do
        before do
          testprotector2.save
          dog.protector_id = testprotector2.id
          dog.save
          relationship.protector_id = testprotector2.id
          relationship.save
          visit protector_path(testprotector2)
        end

        it "アクセスができること" do
          expect(current_path).to eq protector_path(testprotector2)
        end

        it "編集リンクが表示されていないこと" do
          expect(page).to have_no_link "編集"
        end

        it "フォローボタンは表示されていないこと" do
          expect(page).to have_no_css '.follow-btn'
        end

        it "フォロー人数をクリックするとフォローしているuserがモーダル表示されること" do
          find('.follower-count').click
          sleep 3
          expect(page).to have_content user.name
        end

        it "登録済みの画像をクリックするとdog詳細画面へ遷移すること" do
          find('.protector-dog-img').click
          expect(current_path).to eq dog_path(dog)
        end
      end

      context "dogを登録していないページにアクセスした場合" do
        before do
          testprotector2.save
          visit protector_path(testprotector2)
        end

        it "先住動物が存在しない旨の文が表示されること" do
          expect(page).to have_content "保護犬が登録されていません"
        end
      end
    end

    context "userがアクセスした場合", js: true do
      before do
        relationship.save
        dog.save
        visit new_user_session_path
        fill_in 'Eメールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'testpassword'
        click_button 'ログイン'
        visit protector_path(testprotector1)
      end

      it "アクセスができること" do
        expect(current_path).to eq protector_path(testprotector1)
      end

      it "編集リンクが表示されていないこと" do
        expect(page).to have_no_link "編集"
      end

      it "フォローボタンが表示されること" do
        expect(page).to have_css '.follow-btn'
      end

      it "フォロワー人数をクリックするとフォローしているprotectorがモーダル表示されること" do
        find('.follower-count').click
        sleep 3
        expect(page).to have_content user.name
      end

      it "登録済みのdogが表示されていること" do
        expect(page).to have_content dog.name
        expect(page).to have_content dog.age
        expect(page).to have_content dog.gender
      end

      it "登録済みの画像をクリックするとdog詳細画面へ遷移すること" do
        find('.protector-dog-img').click
        expect(current_path).to eq dog_path(dog)
      end
    end
  end
end
