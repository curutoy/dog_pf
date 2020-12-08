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
        find('.post-new-icon').click
        attach_file '写真', "#{Rails.root}/spec/fixtures/files/test.png"
        fill_in 'キャプション', with: 'testpost'
        click_button '投稿'
        expect(current_path).to eq dog_path(dog.id)
      end
    end
  end

end