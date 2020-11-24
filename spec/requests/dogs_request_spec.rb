require 'rails_helper'

RSpec.describe "Dogs", type: :request do
  let!(:user) { create(:user) }
  let!(:protector) { create(:protector) }

  describe "GET /index" do
    context "ログインしていない場合" do
      before do
        get root_path
      end

      it "リクエストが成功すること" do
        expect(response).to have_http_status(200)
      end

      it "home/indexテンプレートが表示されること" do
        expect(response).to render_template "home/index"
      end
    end

    context "userでログイン状態の場合" do
      before do
        sign_in user
        get root_path
      end

      it "リクエストが成功すること" do
        expect(response).to have_http_status(200)
      end

      it "showテンプレートが表示されること" do
        expect(response).to render_template :index
      end
    end

    context "protectorでログイン状態の場合" do
      before do
        sign_in protector
        get root_path
      end

      it "リクエストが成功すること" do
        expect(response).to have_http_status(200)
      end

      it "showテンプレートが表示されること" do
        expect(response).to render_template :index
      end
    end
  end
end
