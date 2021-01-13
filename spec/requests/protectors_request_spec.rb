require 'rails_helper'

RSpec.describe "Protectors", type: :request do
  let!(:protector)    { create(:protector) }
  let!(:user)         { create(:user) }
  let!(:dogs)         { create_list(:dog2, 2, protector_id: protector.id) }
  let!(:relationship) { create(:relationship, protector: protector, user: user) }
  let!(:room)         { create(:room) }
  let!(:entry)        { create(:entry, user: user, protector: protector, room: room) }

  describe "GET /show" do
    context "ログインしていない場合" do
      before do
        get protector_path(protector.id)
      end

      it "status codeが200となること" do
        expect(response).to have_http_status(200)
      end

      it "showテンプレートが表示されること" do
        expect(response).to render_template :show
      end

      it "@protectorが取得できていること" do
        expect(assigns(:protector)).to eq protector
      end

      it "@dogsが取得できていること" do
        expect(assigns(:dogs)).to eq dogs
      end

      it "@relationshipsが取得できていること" do
        expect(assigns(:relationships)).to eq [relationship]
      end
    end

    context "protectorがログインしている場合" do
      before do
        sign_in protector
        get protector_path(protector.id)
      end

      it "status codeが200となること" do
        expect(response).to have_http_status(200)
      end

      it "showテンプレートが表示されること" do
        expect(response).to render_template :show
      end

      it "@protectorが取得できていること" do
        expect(assigns(:protector)).to eq protector
      end

      it "@dogsが取得できていること" do
        expect(assigns(:dogs)).to eq dogs
      end

      it "@relationshipsが取得できていること" do
        expect(assigns(:relationships)).to eq [relationship]
      end
    end

    context "userがログインしている場合" do
      before do
        sign_in user
        get protector_path(protector.id)
      end

      it "status codeが200となること" do
        expect(response).to have_http_status(200)
      end

      it "showテンプレートが表示されること" do
        expect(response).to render_template :show
      end

      it "@protectorが取得できていること" do
        expect(assigns(:protector)).to eq protector
      end

      it "@dogsが取得できていること" do
        expect(assigns(:dogs)).to eq dogs
      end

      it "@relationshipsが取得できていること" do
        expect(assigns(:relationships)).to eq [relationship]
      end

      it "@entryuserが取得できていること" do
        expect(assigns(:entryuser)).to eq [entry]
      end

      it "@entryprotectorが取得できていること" do
        expect(assigns(:entryprotector)).to eq [entry]
      end
    end
  end
end
