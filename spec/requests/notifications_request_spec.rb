require 'rails_helper'

RSpec.describe "Notifications", type: :request do
  let!(:user)          { create(:user) }
  let!(:protector)     { create(:protector) }
  let!(:room)          { create(:room) }
  let!(:message)       { create(:message, user: user, protector: protector, room: room) }
  let!(:notification1) { protector.active_notifications.create(visited_user: user, room: room, message: message, action: 'dm') }
  let!(:dog)           { create(:dog2, protector: protector) }
  let!(:notification2) { user.active_notifications.create(visited_protector: protector, dog: dog, action: 'like') }

  describe "GET /index" do
    context "ログインしていない場合" do
      before do
        get notifications_path
      end

      it "status codeは302となること" do
        expect(response).to have_http_status(302)
      end

      it "home画面へリダイレクトすること" do
        expect(response).to redirect_to root_path
      end
    end

    context "userがログインしている場合" do
      before do
        sign_in user
        get notifications_path
      end

      it "status codeが200となること" do
        expect(response).to have_http_status(200)
      end

      it "indexテンプレートが表示されること" do
        expect(response).to render_template :index
      end

      it "@notificationsが取得できていること" do
        expect(assigns(:notifications)).to eq [notification1]
      end
    end

    context "protectorがログインしている場合" do
      before do
        sign_in protector
        get notifications_path
      end

      it "status codeが200となること" do
        expect(response).to have_http_status(200)
      end

      it "indexテンプレートが表示されること" do
        expect(response).to render_template :index
      end

      it "@entriesが取得できていること" do
        expect(assigns(:notifications)).to eq [notification2]
      end
    end
  end
end
