require 'rails_helper'

RSpec.describe 'Pets', type: :system do
  let!(:user1) { create(:user) }
  let(:pet1) { build(:pet2, user: user1) }

  describe "post_create" do
    before do
      visit new_user_session_path
      fill_in 'Eメールアドレス', with: 'test@example.com'
      fill_in 'パスワード', with: 'testpassword'
      click_button 'ログイン'
      visit user_path(user1.id)
    end

    context "入力に誤りがない場合", js: true do
      it "petの登録を正常に行えること" do
        page.evaluate_script('$(".fade").removeClass("fade")')
        find('.pet-new-icon').click
        sleep 3
        attach_file '写真', "#{Rails.root}/spec/fixtures/files/test.png"
        select '１歳', from: '年齢'
        select '男の子', from: '性別'
        fill_in '性格（50文字以内)', with: 'test charactor'
        click_button '登録'
        expect(current_path).to eq user_path(user1.id)
        expect(page).to have_selector("img[src$='test.png']")
        expect(page).to have_content "１歳"
        expect(page).to have_content "男の子"
        expect(page).to have_content "test charactor"
      end
    end

    context "入力に誤りがある場合", js: true do
      it "petの登録は失敗すること" do
        page.evaluate_script('$(".fade").removeClass("fade")')
        find('.pet-new-icon').click
        sleep 2
        select '１歳', from: '年齢'
        select '男の子', from: '性別'
        fill_in '性格（50文字以内)', with: 'a' * 51
        click_button '登録'
        sleep 1
        expect do
          expect(page.driver.browser.switch_to.alert.text).to eq "投稿内容を確認してください"
          page.driver.browser.switch_to.alert.accept
        end.not_to change(Pet, :count)
      end
    end
  end

  describe "put_update" do
    before do
      pet1.save
      visit new_user_session_path
      fill_in 'Eメールアドレス', with: 'test@example.com'
      fill_in 'パスワード', with: 'testpassword'
      click_button 'ログイン'
      visit user_path(user1.id)
    end

    context "入力に誤りがない場合", js: true do
      it "petの登録を正常に行えること" do
        page.evaluate_script('$(".fade").removeClass("fade")')
        find('.pet-edit-icon').click
        sleep 3
        fill_in '性格（50文字以内)', with: 'change charactor'
        click_button '登録'
        expect(current_path).to eq user_path(user1.id)
        expect(page).to have_content "change charactor"
      end
    end

    context "入力に誤りがある場合", js: true do
      it "petの登録は失敗すること" do
        page.evaluate_script('$(".fade").removeClass("fade")')
        find('.pet-edit-icon').click
        sleep 2
        fill_in '性格（50文字以内)', with: 'a' * 51
        click_button '登録'
        sleep 1
        expect do
          expect(page.driver.browser.switch_to.alert.text).to eq "変更内容を確認してください"
          page.driver.browser.switch_to.alert.accept
        end.not_to change { Pet.find(pet1.id).character }
      end
    end
  end

  describe "post_delete" do
    before do
      pet1.id = 1
      pet1.save
      visit new_user_session_path
      fill_in 'Eメールアドレス', with: 'test@example.com'
      fill_in 'パスワード', with: 'testpassword'
      click_button 'ログイン'
      visit user_path(user1.id)
    end

    context "petを削除する場合", js: true do
      it "正常に削除できること" do
        find('#pet-1').click
        sleep 1
        expect do
          expect(page.driver.browser.switch_to.alert.text).to eq "本当に削除しますか?"
          page.driver.browser.switch_to.alert.accept
          sleep 2
        end.to change(Pet, :count).by(-1)
      end
    end
  end
end
