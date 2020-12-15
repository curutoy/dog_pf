require 'rails_helper'

RSpec.describe 'Dogs', type: :system do
  let!(:user)       { create(:user) }
  let!(:protector)  { create(:protector) }
  let!(:protector2) { create(:protector2) }
  let(:dog)         { create(:dog2, protector_id: protector.id) }
  let(:dog2)        { create(:dog2, protector_id: protector2.id) }

  describe "dog_new" do
    before do
      visit new_protector_session_path
      fill_in 'Eメールアドレス', with: 'protector@example.com'
      fill_in 'パスワード', with: 'testpassword'
      click_button 'ログイン'
      visit new_dog_path
    end

    context "フォームの入力値が正常な場合" do
      it "dogの登録を正常に行えること" do
        attach_file '写真', "#{Rails.root}/spec/fixtures/files/test.png"
        fill_in 'なまえ', with: 'testdog'
        select '１歳', from: '年齢'
        select '東京都', from: '所在地'
        select '男の子', from: '性別'
        select '大型犬', from: '大きさ'
        select '上手', from: 'お散歩'
        select '上手', from: 'お留守番'
        select '上手', from: '犬との関わり'
        select '上手', from: '人との関わり'
        select '済', from: '去勢'
        select '済', from: 'ワクチン'
        select '済', from: 'マイクロチップ'
        select '応募可能', from: '高齢者応募'
        select '応募可能', from: '単身者応募'
        fill_in '紹介文（応募経緯や性格等）(200文字以内)', with: 'testdog'
        fill_in '健康状態(200文字以内)', with: 'testdog'
        fill_in '応募条件(200文字以内)', with: 'testdog'
        click_button '送信'
        expect(current_path).to eq root_path
        expect(page).to have_content("testdog")
      end

      it "必須項目以外は未入力でも登録を正常に行えること" do
        attach_file '写真', "#{Rails.root}/spec/fixtures/files/test.png"
        fill_in 'なまえ', with: 'testdog'
        select '１歳', from: '年齢'
        select '東京都', from: '所在地'
        select '男の子', from: '性別'
        select '大型犬', from: '大きさ'
        select '上手', from: 'お散歩'
        select '上手', from: 'お留守番'
        select '上手', from: '犬との関わり'
        select '上手', from: '人との関わり'
        select '済', from: '去勢'
        select '済', from: 'ワクチン'
        select '済', from: 'マイクロチップ'
        select '応募可能', from: '高齢者応募'
        select '応募可能', from: '単身者応募'
        click_button '送信'
        expect(current_path).to eq root_path
        expect(page).to have_content "testdog"
      end
    end

    context "フォームの入力に誤りのある場合" do
      it "必須項目が未入力の際はエラーとなること" do
        attach_file '写真', "#{Rails.root}/spec/fixtures/files/test.png"
        fill_in 'なまえ', with: ''
        select '１歳', from: '年齢'
        select '東京都', from: '所在地'
        select '男の子', from: '性別'
        select '大型犬', from: '大きさ'
        select '上手', from: 'お散歩'
        select '上手', from: 'お留守番'
        select '上手', from: '犬との関わり'
        select '上手', from: '人との関わり'
        select '済', from: '去勢'
        select '済', from: 'ワクチン'
        select '済', from: 'マイクロチップ'
        select '応募可能', from: '高齢者応募'
        select '応募可能', from: '単身者応募'
        click_button '送信'
        expect(page).to have_content "なまえ が入力されていません。"
      end

      it "長さに上限のある項目が上限を超えてしまうとエラーとなること" do
        attach_file '写真', "#{Rails.root}/spec/fixtures/files/test.png"
        fill_in 'なまえ', with: 'a' * 21
        select '１歳', from: '年齢'
        select '東京都', from: '所在地'
        select '男の子', from: '性別'
        select '大型犬', from: '大きさ'
        select '上手', from: 'お散歩'
        select '上手', from: 'お留守番'
        select '上手', from: '犬との関わり'
        select '上手', from: '人との関わり'
        select '済', from: '去勢'
        select '済', from: 'ワクチン'
        select '済', from: 'マイクロチップ'
        select '応募可能', from: '高齢者応募'
        select '応募可能', from: '単身者応募'
        click_button '送信'
        expect(page).to have_content "なまえ は20文字以下に設定して下さい。"
      end
    end
  end

  describe "dog_show" do
    context "protectorがサインインした場合", js: true do
      before do
        visit new_protector_session_path
        fill_in 'Eメールアドレス', with: 'protector@example.com'
        fill_in 'パスワード', with: 'testpassword'
        click_button 'ログイン'
      end

      context "自身が登録したページにアクセスした場合" do
        before do
          visit dog_path(id: dog.id)
        end

        it "アクセスができること" do
          expect(current_path).to eq dog_path(id: dog.id)
        end

        it "編集リンクが表示されていること" do
          expect(page).to have_link "編集"
        end

        it 'お気に入りのカウントがボタン表示となっていること' do
          expect(page).to have_css '.like-count'
        end

        it "削除アイコンが表示されていること" do
          expect(page).to have_css '.dog-destroy-btn'
        end

        it "日常を投稿できるアイコンから新規投稿モーダルを表示できること" do
          page.evaluate_script('$(".fade").removeClass("fade")')
          find('.post-new-icon').click
          sleep 3
          expect(page).to have_content "写真"
          expect(page).to have_content "キャプション"
        end
      end

      context "自分以外が登録したページ気アクセスした場合" do
        before do
          visit dog_path(id: dog2.id)
        end

        it "アクセスができること" do
          expect(current_path).to eq dog_path(id: dog2.id)
        end

        it "編集リンクが表示されていないこと" do
          expect(page).to have_no_link "編集"
        end

        it 'お気に入りのカウントがボタン表示ではないこと' do
          expect(page).to have_no_css '.like-count-btn'
        end

        it "削除アイコンが表示されていること" do
          expect(page).to have_no_css '.dog-destroy-btn'
        end

        it "日常を投稿できるアイコンが表示されていないこと" do
          expect(page).to have_no_css '.post-new-icon'
        end
      end
    end

    context "userがサインインした場合" do
      before do
        visit new_user_session_path
        fill_in 'Eメールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'testpassword'
        click_button 'ログイン'
        visit dog_path(id: dog.id)
      end

      it "アクセスができること" do
        expect(current_path).to eq dog_path(id: dog.id)
      end

      it "お気に入り登録ボタンが表示されていること" do
        expect(page).to have_css '.like-btn'
      end

      it 'お気に入りのカウントがボタン表示ではないこと' do
        expect(page).to have_no_css '.like-count-btn'
      end
    end
  end

  describe "dog_edit/update" do
    before do
      visit new_protector_session_path
      fill_in 'Eメールアドレス', with: 'protector@example.com'
      fill_in 'パスワード', with: 'testpassword'
      click_button 'ログイン'
    end

    context "自身が登録したdogの編集ページにアクセスした場合" do
      before do
        visit edit_dog_path(id: dog.id)
      end

      it "アクセスができること" do
        expect(current_path).to eq edit_dog_path dog
      end

      context "フォームの入力値が正常である場合" do
        it "正常に更新が行えること" do
          fill_in 'なまえ', with: 'change_name'
          click_button '更新'
          expect(current_path).to eq dog_path dog
          expect(page).to have_content "change_name"
        end
      end

      context "フォーム入力値に誤りがある場合" do
        it "nameを削除した際はエラーとなること" do
          fill_in 'なまえ', with: ''
          click_button '更新'
          expect(page).to have_content "なまえ が入力されていません。"
        end

        it "長さに上限のある項目が上限を超えてしまうとエラーとなること" do
          fill_in 'なまえ', with: 'a' * 21
          click_button '更新'
          expect(page).to have_content "なまえ は20文字以下に設定して下さい。"
        end
      end
    end

    context "自身が登録したdog以外の編集ページにアクセスした場合" do
      it "アクセスができないこと" do
        visit edit_dog_path(id: dog2.id)
        expect(current_path).to eq root_path
        expect(page).to have_content "投稿者のみ閲覧できるページです。"
      end
    end
  end

  describe "dog_delete" do
    before do
      visit new_protector_session_path
      fill_in 'Eメールアドレス', with: 'protector@example.com'
      fill_in 'パスワード', with: 'testpassword'
      click_button 'ログイン'
    end

    context "自身が登録したdogの編集ページにアクセスした場合", js: true do
      before do
        visit dog_path(id: dog.id)
      end

      it "正常に削除ができること" do
        find('.dog-destroy-btn').click
        expect do
          expect(page.driver.browser.switch_to.alert.text).to eq "本当に削除しますか?"
          page.driver.browser.switch_to.alert.accept
          sleep 2
        end.to change(Dog, :count).by(-1)
        expect(current_path).to eq root_path
      end
    end
  end
end
