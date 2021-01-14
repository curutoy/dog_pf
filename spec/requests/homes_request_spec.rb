require 'rails_helper'

RSpec.describe "Homes", type: :request do
  describe "GET /index" do
    context "ログインしていない場合" do
      before do
        get homes_path
      end

      it "status codeは200となること" do
        expect(response).to have_http_status(200)
      end

      it "indexテンプレートが表示されること" do
        expect(response).to render_template :index
      end
    end

    context "userでログイン状態の場合" do
      before do
        get homes_path
      end

      it "status codeは200となること" do
        expect(response).to have_http_status(200)
      end

      it "indexテンプレートが表示されること" do
        expect(response).to render_template :index
      end
    end

    context "protectorでログイン状態の場合" do
      before do
        get homes_path
      end

      it "status codeは200となること" do
        expect(response).to have_http_status(200)
      end

      it "indexテンプレートが表示されること" do
        expect(response).to render_template :index
      end
    end
  end
end
