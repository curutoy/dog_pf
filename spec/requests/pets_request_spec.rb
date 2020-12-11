require 'rails_helper'

RSpec.describe "Pets", type: :request do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user2) }
  let(:pet1)  { build(:pet2, user: user2) }
  let(:pet2)  { build(:pet2, user: user1) }

  describe "POST /create" do
    context "userがログインしている場合" do
      before do
        sign_in user1
      end

      it 'リクエストが成功すること' do
        post user_pets_path(user_id: user1.id), params: { pet: attributes_for(:pet2) }
        expect(response).to have_http_status(302)
      end

      it '入力に誤りがない場合は投稿が成功すること' do
        expect do
          post user_pets_path(user_id: user1.id), params: { pet: attributes_for(:pet2) }
        end.to change(Pet, :count).by(1)
      end

      it "入力が誤っていた場合投稿が失敗すること" do
        expect do
          post user_pets_path(user_id: user1.id), params: { pet: attributes_for(:pet2, :invalid) }
        end.not_to change(Pet, :count)
      end

      it "自分以外のpetを登録できないこと" do
        post user_pets_path(user_id: user2.id), params: { pet: attributes_for(:pet2) }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to user_path(user2)
      end
    end
  end

  describe "POST /edit" do
    context "userがログインしている場合" do
      before do
        sign_in user1
        pet1.save
        pet2.save
      end

      it 'リクエストが成功すること' do
        put user_pet_path(user_id: user1.id, id: pet2.id), params: { pet: attributes_for(:pet3) }
        expect(response).to have_http_status(302)
      end

      it '入力に誤りがない場合は編集が成功すること' do
        expect do
          put user_pet_path(user_id: user1.id, id: pet2.id), params: { pet: attributes_for(:pet3) }
        end.to change { Pet.find(pet2.id).age }.from('１歳').to('２歳')
      end

      it "入力が誤っていた場合編集が失敗すること" do
        expect do
          put user_pet_path(user_id: user1.id, id: pet2.id), params: { pet: attributes_for(:pet3, :invalid) }
        end.not_to change { Pet.find(pet2.id).age }
      end

      it "自分以外のpetを編集できないこと" do
        put user_pet_path(user_id: user1.id, id: pet1.id), params: { pet: attributes_for(:pet3) }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to user_path(user1)
      end
    end
  end

  describe "DELETE /destroy" do
    context "protectorがログインしている場合" do
      before do
        sign_in user1
        pet1.save
        pet2.save
      end

      it "リクエストが成功すること" do
        delete user_pet_path(user_id: user1.id, id: pet2.id)
        expect(response).to have_http_status(302)
      end

      it "削除ができること" do
        expect { delete user_pet_path(user_id: user1.id, id: pet2.id) }.to change(Pet, :count).by(-1)
      end

      it "user画面へリダイレクトすること" do
        delete user_pet_path(user_id: user1.id, id: pet2.id)
        expect(response).to redirect_to user_path(user1)
      end

      it "自分以外のpetを削除できないこと" do
        delete user_pet_path(user_id: user1.id, id: pet1.id)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to user_path(user1)
      end
    end
  end
end
