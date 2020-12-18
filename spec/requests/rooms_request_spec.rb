require 'rails_helper'

RSpec.describe "Rooms", type: :request do
  let!(:user)      { create(:user) }
  let!(:protector) { create(:protector) }
  let!(:room)      { create(:room) }
  let!(:entry)     { create(:entry, user: user, protector: protector, room: room) }

  describe "POST /create" do
    context "userがログインしている場合" do
      before do
        sign_in user
      end

      it "status codeが302となること" do
        post rooms_path, params: { room: attributes_for(:room), entry: { protector: protector } }
        expect(response).to have_http_status(302)
      end

      it "Roomが作成されること" do
        expect do
          post rooms_path, params: { room: attributes_for(:room), entry: { protector: protector } }
        end.to change(Room, :count).by(1)
      end

      it "room詳細画面へ遷移すること" do
        post rooms_path, params: { room: attributes_for(:room), entry: { protector: protector } }
        expect(response).to redirect_to Room.last
      end
    end

    context "protectorがログインしている場合" do
      before do
        sign_in protector
      end

      it "status codeが302となること" do
        post rooms_path, params: { room: attributes_for(:room), entry: { user: user } }
        expect(response).to have_http_status(302)
      end

      it "Roomが作成されること" do
        expect do
          post rooms_path, params: { room: attributes_for(:room), entry: { user: user } }
        end.to change(Room, :count).by(1)
      end

      it "room詳細画面へ遷移すること" do
        post rooms_path, params: { room: attributes_for(:room), entry: { user: user } }
        expect(response).to redirect_to Room.last
      end
    end
  end

  describe "GET /index" do
    context "ログインしていない場合" do
      before do
        get rooms_path
      end

      it "status codeが302となること" do
        expect(response).to have_http_status(302)
      end

      it "home画面にリダイレクトすること" do
        expect(response).to redirect_to root_path
      end
    end

    context "userがログインしている場合" do
      before do
        sign_in user
        get rooms_path
      end

      it "status codeが200となること" do
        expect(response).to have_http_status(200)
      end

      it "indexテンプレートが表示されること" do
        expect(response).to render_template :index
      end

      it "@entriesが取得できていること" do
        expect(assigns(:entries)).to eq [entry]
      end
    end

    context "protectorがログインしている場合" do
      before do
        sign_in protector
        get rooms_path
      end

      it "status codeが200となること" do
        expect(response).to have_http_status(200)
      end

      it "indexテンプレートが表示されること" do
        expect(response).to render_template :index
      end

      it "@entriesが取得できていること" do
        expect(assigns(:entries)).to eq [entry]
      end
    end
  end

  describe "GET /show" do
    let!(:user2)      { create(:user2) }
    let!(:protector2) { create(:protector2) }
    let!(:room2)      { create(:room) }
    let!(:entry2)     { create(:entry, user: user2, protector: protector2, room: room2) }
    let!(:message)    { create(:message, user: user, protector: protector, room: room) }

    context "ログインしていない場合" do
      before do
        get room_path(room)
      end

      it "status codeが302となること" do
        expect(response).to have_http_status(302)
      end

      it "home画面にリダイレクトすること" do
        expect(response).to redirect_to root_path
      end
    end

    context "userがログインしている場合" do
      before do
        sign_in user
        get room_path(room)
      end

      context "自身の所属するroomへアクセスした場合" do
        it "status codeが200となること" do
          expect(response).to have_http_status(200)
        end

        it "showテンプレートが表示されること" do
          expect(response).to render_template :show
        end

        it "@roomが取得できていること" do
          expect(assigns(:room)).to eq room
        end

        it "@messagesが取得できていること" do
          expect(assigns(:messages)).to eq [message]
        end

        it "@entriesが取得できていること" do
          expect(assigns(:entries)).to eq [entry]
        end
      end

      context "自分が所属するroom以外のroomへアクセスした場合" do
        it "status codeは200となること" do
          expect(response).to have_http_status(200)
        end

        it "home画面へリダイレクトすること" do
          get room_path(room2)
          expect(response).to redirect_to root_path
        end
      end
    end

    context "protectorがログインしている場合" do
      before do
        sign_in protector
        get room_path(room)
      end

      context "自身の所属するroomへアクセスした場合" do
        it "status codeが200となること" do
          expect(response).to have_http_status(200)
        end

        it "showテンプレートが表示されること" do
          expect(response).to render_template :show
        end

        it "@roomが取得できていること" do
          expect(assigns(:room)).to eq room
        end

        it "@messagesが取得できていること" do
          expect(assigns(:messages)).to eq [message]
        end

        it "@entriesが取得できていること" do
          expect(assigns(:entries)).to eq [entry]
        end
      end

      context "自分が所属するroom以外のroomへアクセスした場合" do
        it "status codeは200となること" do
          expect(response).to have_http_status(200)
        end

        it "home画面へリダイレクトすること" do
          get room_path(room2)
          expect(response).to redirect_to root_path
        end
      end
    end
  end
end
