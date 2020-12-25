require 'rails_helper'

RSpec.describe 'Events', type: :system do
  let!(:user)       { create(:user) }
  let!(:protector1) { create(:protector) }
  let!(:protector2) { create(:protector2) }
  let(:event1)      { build(:event, protector: protector1) }
  let(:event2)      { build(:event2, protector: protector2) }

  describe "event_new" do
    before do
      visit new_protector_session_path
      fill_in 'Eメールアドレス', with: 'protector@example.com'
      fill_in 'パスワード', with: 'testpassword'
      click_button 'ログイン'
      visit new_event_path
    end

    context "フォームの入力値が正常な場合" do
      it "eventの登録を正常に行えること" do
        find('#event_due_on_1i').find("option[value='2020']").select_option
        find('#event_due_on_2i').find("option[value='1']").select_option
        find('#event_due_on_3i').find("option[value='1']").select_option
        find('#event_start_at_4i').find("option[value='00']").select_option
        find('#event_start_at_5i').find("option[value='00']").select_option
        find('#event_finish_at_4i').find("option[value='00']").select_option
        find('#event_finish_at_5i').find("option[value='00']").select_option
        select '東京都', from: '開催地（都道府県）'
        fill_in '開催地（住所）', with: '東京都新宿区新宿３丁目３８'
        fill_in '説明（200文字以内)', with: 'test content'
        click_button '送信'
        expect(current_path).to eq events_path
        expect(page).to have_content("東京都")
      end

      it "必須項目以外は未入力でも登録を正常に行えること" do
        find('#event_due_on_1i').find("option[value='2020']").select_option
        find('#event_due_on_2i').find("option[value='1']").select_option
        find('#event_due_on_3i').find("option[value='1']").select_option
        find('#event_start_at_4i').find("option[value='00']").select_option
        find('#event_start_at_5i').find("option[value='00']").select_option
        find('#event_finish_at_4i').find("option[value='00']").select_option
        find('#event_finish_at_5i').find("option[value='00']").select_option
        select '東京都', from: '開催地（都道府県）'
        fill_in '開催地（住所）', with: '東京都新宿区新宿３丁目３８'
        fill_in '説明（200文字以内)', with: ' '
        click_button '送信'
        expect(current_path).to eq events_path
        expect(page).to have_content("東京都")
      end
    end

    context "フォームの入力に誤りのある場合" do
      it "必須項目が未入力の際はエラーとなること" do
        find('#event_due_on_1i').find("option[value='2020']").select_option
        find('#event_due_on_2i').find("option[value='1']").select_option
        find('#event_due_on_3i').find("option[value='1']").select_option
        find('#event_start_at_4i').find("option[value='00']").select_option
        find('#event_start_at_5i').find("option[value='00']").select_option
        find('#event_finish_at_4i').find("option[value='00']").select_option
        find('#event_finish_at_5i').find("option[value='00']").select_option
        select '東京都', from: '開催地（都道府県）'
        fill_in '開催地（住所）', with: ''
        fill_in '説明（200文字以内)', with: 'test content'
        click_button '送信'
        expect(page).to have_content("開催地（住所） が入力されていません。")
      end

      it "長さに上限のある項目が上限を超えてしまうとエラーとなること" do
        find('#event_due_on_1i').find("option[value='2020']").select_option
        find('#event_due_on_2i').find("option[value='1']").select_option
        find('#event_due_on_3i').find("option[value='1']").select_option
        find('#event_start_at_4i').find("option[value='00']").select_option
        find('#event_start_at_5i').find("option[value='00']").select_option
        find('#event_finish_at_4i').find("option[value='00']").select_option
        find('#event_finish_at_5i').find("option[value='00']").select_option
        select '東京都', from: '開催地（都道府県）'
        fill_in '開催地（住所）', with: '東京都新宿区新宿３丁目３８'
        fill_in '説明（200文字以内)', with: 'a' * 201
        click_button '送信'
        expect(page).to have_content("説明 は200文字以下に設定して下さい。")
      end
    end
  end

  describe "event_index" do
    context "protectorがサインインした場合" do
      before do
        event2.save
        visit new_protector_session_path
        fill_in 'Eメールアドレス', with: 'protector@example.com'
        fill_in 'パスワード', with: 'testpassword'
        click_button 'ログイン'
        visit events_path
      end

      it "アクセスができること" do
        expect(current_path).to eq events_path
      end

      it "「表示内容」が「全て」と表示されていること" do
        expect(page).to have_content "全て"
      end

      it "全てのeventが表示されていること" do
        event1.save
        expect(page).to have_content event1.prefecture
        expect(page).to have_content event2.prefecture
      end

      it "検索を行うと「表示内容」が検索内容に変わること" do
        select '東京都', from: '開催地（都道府県）'
        find('.event-search-btn').click
        expect(page).to have_content "表示内容： 東京都"
      end

      it "検索が正常に行われること" do
        event1.save
        select '東京都', from: '開催地（都道府県）'
        find('.event-search-btn').click
        expect(page).to have_content event1.prefecture
        expect(page).to have_no_content("千葉県", count: 2)
      end

      it "イベント投稿のアイコンをクリックすると投稿画面へ遷移すること" do
        find('.event-link-icon').click
        expect(current_path).to eq new_event_path
      end

      it "protectorの画像をクリックするとevent詳細ページへ遷移すること" do
        find('.event-show-link').click
        expect(current_path).to eq event_path(event2)
      end
    end

    context "userがサインインした場合" do
      before do
        event2.save
        visit new_user_session_path
        fill_in 'Eメールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'testpassword'
        click_button 'ログイン'
        visit events_path
      end

      it "アクセスができること" do
        expect(current_path).to eq events_path
      end

      it "「表示内容」が「全て」と表示されていること" do
        expect(page).to have_content "全て"
      end

      it "全てのeventが表示されていること" do
        event1.save
        expect(page).to have_content event1.prefecture
        expect(page).to have_content event2.prefecture
      end

      it "検索を行うと「表示内容」が検索内容に変わること" do
        select '東京都', from: '開催地（都道府県）'
        find('.event-search-btn').click
        expect(page).to have_content "表示内容： 東京都"
      end

      it "検索が正常に行われること" do
        event1.save
        select '東京都', from: '開催地（都道府県）'
        find('.event-search-btn').click
        expect(page).to have_content event1.prefecture
        expect(page).to have_no_content("千葉県", count: 2)
      end

      it "イベント投稿のアイコンが表示されていないこと" do
        expect(page).to have_no_css('event-new-icon')
      end

      it "protectorの画像をクリックするとevent詳細ページへ遷移すること" do
        find('.event-show-link').click
        expect(current_path).to eq event_path(event2)
      end
    end
  end

  describe "event_show" do
    context "protectorがサインインした場合", js: true do
      before do
        event1.save
        event2.save
        visit new_protector_session_path
        fill_in 'Eメールアドレス', with: 'protector@example.com'
        fill_in 'パスワード', with: 'testpassword'
        click_button 'ログイン'
      end

      context "自身が登録したページにアクセスした場合" do
        before do
          visit event_path(event1.id)
        end

        it "アクセスができること" do
          expect(current_path).to eq event_path(event1.id)
        end

        it "編集アイコンが表示されており、編集モーダルを表示できること" do
          find('.event-edit-icon').click
          sleep 3
          expect(page).to have_css '.event-edit'
        end

        it "削除アイコンが表示されていること" do
          expect(page).to have_css '.event-delete-icon'
        end

        it "投稿した内容が表示されていること" do
          expect(page).to have_content "東京都新宿区新宿３丁目３８"
        end
      end

      context "自分以外が登録したページ気アクセスした場合" do
        before do
          visit event_path(event2.id)
        end

        it "アクセスができること" do
          expect(current_path).to eq event_path(event2.id)
        end

        it "編集アイコンが表示されていないこと" do
          expect(page).to have_no_css '.event-edit-icon'
        end

        it '削除アイコンが表示されいないこと' do
          expect(page).to have_no_css '.event-delete-icon'
        end

        it "登録されている内容が表示されていること" do
          expect(page).to have_content "千葉県千葉市"
        end
      end
    end

    context "userがサインインした場合" do
      before do
        event1.save
        visit new_user_session_path
        fill_in 'Eメールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'testpassword'
        click_button 'ログイン'
        visit event_path(event1)
      end

      it "アクセスができること" do
        expect(current_path).to eq event_path(event1)
      end

      it "編集アイコンが表示されていないこと" do
        expect(page).to have_no_css '.event-edit-icon'
      end

      it '削除アイコンが表示されいないこと' do
        expect(page).to have_no_css '.event-delete-icon'
      end

      it "登録されている内容が表示されていること" do
        expect(page).to have_content "東京都新宿区新宿３丁目３８"
      end
    end
  end

  describe "event_update" do
    before do
      event1.save
      visit new_protector_session_path
      fill_in 'Eメールアドレス', with: 'protector@example.com'
      fill_in 'パスワード', with: 'testpassword'
      click_button 'ログイン'
      visit event_path(event1.id)
    end

    context "入力に誤りがない場合", js: true do
      it "petの登録を正常に行えること" do
        page.evaluate_script('$(".fade").removeClass("fade")')
        find('.event-edit-icon').click
        sleep 3
        fill_in '説明（200文字以内)', with: 'change content'
        click_button '送信'
        expect(current_path).to eq event_path(event1.id)
        expect(page).to have_content "change content"
      end
    end

    context "入力に誤りがある場合", js: true do
      it "petの登録は失敗すること" do
        page.evaluate_script('$(".fade").removeClass("fade")')
        find('.event-edit-icon').click
        sleep 2
        fill_in '説明（200文字以内)', with: 'a' * 201
        click_button '送信'
        sleep 2
        expect do
          expect(page.driver.browser.switch_to.alert.text).to eq "変更内容を確認してください"
          page.driver.browser.switch_to.alert.accept
        end.not_to change { Event.find(event1.id).content }
      end
    end
  end

  describe "dog_delete" do
    before do
      event1.save
      visit new_protector_session_path
      fill_in 'Eメールアドレス', with: 'protector@example.com'
      fill_in 'パスワード', with: 'testpassword'
      click_button 'ログイン'
    end

    context "自身が登録したdogの編集ページにアクセスした場合", js: true do
      before do
        visit event_path(event1.id)
      end

      it "正常に削除ができること" do
        find('.event-delete-icon').click
        expect do
          expect(page.driver.browser.switch_to.alert.text).to eq "本当に削除しますか?"
          page.driver.browser.switch_to.alert.accept
          sleep 2
        end.to change(Event, :count).by(-1)
        expect(current_path).to eq events_path
      end
    end
  end
end
