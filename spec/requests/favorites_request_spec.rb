require 'rails_helper'

RSpec.describe "Favorites", type: :request do
  let!(:user)        { create(:user) }
  let!(:user2)       { create(:user2) }
  let!(:protector)   { create(:protector) }
  let!(:dog)         { create(:dog2, protector: protector) }
  let(:favorite)     { build(:favorite, user: user, dog: dog) }

  describe "POST /create" do
    context "userがログインしている場合" do
      before do
        sign_in user
      end

      it "リクエストが成功すること" do
        post favorites_path, params: { dog_id: dog.id }
        expect(response).to have_http_status(302)
      end

      it "@favoritesの値が取得できていること" do
        post favorites_path, params: { dog_id: dog.id }
        expect(assigns(:dog)).to eq dog
      end

      it "お気に入り登録が成功すること" do
        expect do
          post favorites_path, params: { dog_id: dog.id }
        end.to change(Favorite, :count).by(1)
      end

      it "notificationが登録されること" do
        expect do
          post favorites_path, params: { dog_id: dog.id }
        end.to change(Notification, :count).by(1)
      end

      it "dog画面へリダイレクトすること" do
        post favorites_path, params: { dog_id: dog.id }
        expect(response).to redirect_to dog_path(dog)
      end
    end
  end

  describe "GET /index" do
    context "ログインしていない場合" do
      before do
        get user_favorites_path(user)
      end

      it "staus codeは302となること" do
        expect(response).to have_http_status(302)
      end

      it "ホーム画面へ遷移すること" do
        expect(response).to redirect_to root_path
      end
    end

    context "userがログインしている場合" do
      before do
        sign_in user
        favorite.save
        get user_favorites_path(user)
      end

      it "status codeは200となること" do
        expect(response).to have_http_status(200)
      end

      it "indexテンプレートが表示されていること" do
        expect(response).to render_template :index
      end

      it "@favoritesの値が取得できていること" do
        expect(assigns(:favorites)).to eq [favorite]
      end

      it "current_user以外はページへアクセスできないこと" do
        get user_favorites_path(user2)
        expect(response).to redirect_to root_path
      end
    end

    context "protectorがログインしている場合" do
      before do
        favorite.save
        sign_in protector
        get user_favorites_path(user)
      end

      it "status codeは302となること" do
        expect(response).to have_http_status(302)
      end

      it "current_user以外はページへアクセスできないこと" do
        expect(response).to redirect_to root_path
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
