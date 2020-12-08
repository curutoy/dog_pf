require 'rails_helper'

RSpec.describe 'Posts', type: :system do
  let!(:protector) { create(:protector) }
  let!(:dog)       { create(:dog2, protector: protector) }
  let!(:delete_post) { build(:post2, dog: dog) }

  describe "post_create" do
    before do
      visit new_protector_session_path
      fill_in 'Eメールアドレス', with: 'protector@example.com'
      fill_in 'パスワード', with: 'testpassword'
      click_button 'ログイン'
      visit dog_path(dog.id)
    end

    context "入力に誤りがない場合", js: true do
      it "postの登録を正常に行えること" do
        page.evaluate_script('$(".fade").removeClass("fade")')
        find('.post-new-icon').click
        sleep 3
        attach_file '写真', "#{Rails.root}/spec/fixtures/files/test.png"
        fill_in 'キャプション', with: 'testpost'
        click_button '投稿'
        expect(current_path).to eq dog_path(dog.id)
        expect(page).to have_selector("img[src$='test.png']")
      end
    end

    context "入力に誤りがある場合", js: true do
      it "postの登録は失敗すること" do
        page.evaluate_script('$(".fade").removeClass("fade")')
        find('.post-new-icon').click
        sleep 2
        fill_in 'キャプション', with: 'a' * 201
        click_button '投稿'
        sleep 1
        expect do
          expect(page.driver.browser.switch_to.alert.text).to eq "投稿内容を確認してください"
          page.driver.browser.switch_to.alert.accept
        end.to change(Post, :count).by(0)
      end
    end
  end

  describe "post_delete" do
    before do
      delete_post.id = 1
      delete_post.save
      visit new_protector_session_path
      fill_in 'Eメールアドレス', with: 'protector@example.com'
      fill_in 'パスワード', with: 'testpassword'
      click_button 'ログイン'
      visit dog_path(dog.id)
    end

    context "postを削除する場合", js: true do
      it "正常に削除できること" do
        click_on 'post-1'
        sleep 2
        find('.post-delete-icon').click
        sleep 1
        expect do
          expect(page.driver.browser.switch_to.alert.text).to eq "本当に削除しますか?"
          page.driver.browser.switch_to.alert.accept
          sleep 2
        end.to change(Post, :count).by(-1)
      end
    end
  end
end
