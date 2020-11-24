require 'rails_helper'

RSpec.describe "Protectors", type: :request do
  let!(:protector) { create(:protector) }

  describe "GET /show" do
    context "ログインしていない場合" do
      before do
        get protector_path(protector.id)
      end

      it "リクエストはエラーが発生すること" do
        expect(response).to have_http_status(302)
      end

      it "protectorのログインページにリダイレクトされること" do
        expect(response).to redirect_to root_path
      end

      it "メッセージが表示されること" do
        expect(flash[:alert]).to eq "アカウント登録もしくはログインしてください。"
      end
    end

    context "ログイン状態の場合" do
      before do
        sign_in protector
        get protector_path(protector.id)
      end
  
      it "リクエストが成功すること" do
        expect(response).to have_http_status(200)
      end

      it "showテンプレートが表示されること" do
        expect(response).to render_template :show
      end

      it "@protectorが取得できていること" do
        expect(assigns :protector).to eq protector
      end
    end
  end
end
