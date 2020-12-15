require 'rails_helper'

RSpec.describe "Favorites", type: :request do
  let!(:user)      { create(:user) }
  let!(:user2)     { create(:user2) }
  let!(:dog)       { create(:dog2) }
  let(:favorite)   { build(:favorite, user: user, dog: dog) }

  describe "POST /create" do
    context "userがログインしている場合" do
      before do
        sign_in user
      end

      it "リクエストが成功すること" do
        post favorites_path, params: { dog_id: dog.id }
        expect(response).to have_http_status(302)
      end

      it "@dogの値が取得できていること" do
        post favorites_path, params: { dog_id: dog.id }
        expect(assigns(:dog)).to eq dog
      end

      it "お気に入り登録が成功すること" do
        expect do
          post favorites_path, params: { dog_id: dog.id }
        end.to change(Favorite, :count).by(1)
      end

      it "dog画面へリダイレクトすること" do
        post favorites_path, params: { dog_id: dog.id }
        expect(response).to redirect_to dog_path(dog)
      end
    end
  end

  describe "GET /index" do
    context "userがログインしている場合" do
      before do
        sign_in user
        favorite.save
        get user_favorites_path(user)
      end

      it "リクエストが成功すること" do
        expect(response).to have_http_status(200)
      end

      it "indexテンプレートが表示されていること" do
        expect(response).to render_template :index
      end

      it "@dogsの値が取得できていること" do
        expect(assigns(:dogs)).to eq [dog]
      end

      it "current_user以外はページへアクセスできないこと画面へリダイレクトすること" do
        get user_favorites_path(user2)
        expect(response).to redirect_to user_path(user)
      end
    end
  end

  describe "DELETE /destroy" do
    context "protectorがログインしている場合" do
      before do
        sign_in user
        favorite.save
      end

      it "リクエストが成功すること" do
        delete favorite_path(id: favorite.id)
        expect(response).to have_http_status(302)
      end

      it "@dogの値が取得できていること" do
        delete favorite_path(id: favorite.id)
        expect(assigns(:dog)).to eq dog
      end

      it "フォロー解除ができること" do
        expect { delete favorite_path(id: favorite.id) }.to change(Favorite, :count).by(-1)
      end

      it "dog画面へリダイレクトすること" do
        delete favorite_path(id: favorite.id)
        expect(response).to redirect_to dog_path(dog)
      end
    end
  end
end
