require 'rails_helper'

RSpec.describe "Users", type: :request do
  let!(:user)         { create(:user) }
  let!(:relationship) { create(:relationship, user: user) }

  describe "GET /show" do
    context "ログインしていない場合" do
      before do
        get user_path(user.id)
      end

      it "リクエストはエラーが発生すること" do
        expect(response).to have_http_status(302)
      end

      it "ホーム画面にリダイレクトされること" do
        expect(response).to redirect_to root_path
      end

      it "メッセージが表示されること" do
        expect(flash[:alert]).to eq "アカウント登録もしくはログインしてください。"
      end
    end

    context "ログイン状態の場合" do
      before do
        sign_in user
        get user_path(user.id)
      end

      it "リクエストが成功すること" do
        expect(response).to have_http_status(200)
      end

      it "showテンプレートが表示されること" do
        expect(response).to render_template :show
      end

      it "@userが取得できていること" do
        expect(assigns(:user)).to eq user
      end

      it "@relationshipsが取得できていること" do
        expect(assigns(:relationships)).to eq [relationship]
      end
    end
  end
end
