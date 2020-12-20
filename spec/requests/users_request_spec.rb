require 'rails_helper'

RSpec.describe "Users", type: :request do
  let!(:user)         { create(:user) }
  let!(:protector)    { create(:protector) }
  let!(:relationship) { create(:relationship, user: user, protector: protector) }
  let!(:room)         { create(:room) }
  let!(:entry)        { create(:entry, user: user, protector: protector, room: room) }

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

    context "userがログインしている場合" do
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

    context "protectorがログインしている場合" do
      before do
        sign_in protector
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

      it "@entryprotectorが取得できていること" do
        expect(assigns(:entryprotector)).to eq [entry]
      end

      it "@entryuserが取得できていること" do
        expect(assigns(:entryuser)).to eq [entry]
      end
    end
  end
end
