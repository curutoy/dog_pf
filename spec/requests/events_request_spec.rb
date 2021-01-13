require 'rails_helper'

RSpec.describe "Events", type: :request do
  let!(:user)       { create(:user) }
  let!(:protector1) { create(:protector) }
  let!(:protector2) { create(:protector2) }
  let(:event1)      { build(:event, protector: protector1) }
  let!(:event2)     { build(:event, protector: protector2) }
  let!(:events)     { create_list(:event, 2, protector: protector1) }

  describe "GET /new" do
    context "ログインしていない場合" do
      before do
        get new_event_path
      end

      it "status codeが200となること" do
        expect(response).to have_http_status(200)
      end

      it "home画面が表示されるされること" do
        expect(response).to render_template "home/index"
      end
    end

    context "userでログイン状態の場合" do
      before do
        sign_in user
        get new_event_path
      end

      it "status codeが302となること" do
        expect(response).to have_http_status(302)
      end

      it "dog/index画面へリダイレクトされること" do
        expect(response).to redirect_to root_path
      end
    end

    context "protectorでログイン状態の場合" do
      before do
        sign_in protector1
        get new_event_path
      end

      it "status codeが200となること" do
        expect(response).to have_http_status(200)
      end

      it "newテンプレートが表示されること" do
        expect(response).to render_template :new
      end
    end
  end

  describe "Post /create" do
    before do
      sign_in protector1
    end

    context "入力内容に誤りがない場合" do
      it 'リクエストが成功すること' do
        post events_path, params: { event: attributes_for(:event) }
        expect(response).to have_http_status(302)
      end

      it "投稿が成功すること" do
        expect do
          post events_path, params: { event: attributes_for(:event) }
        end.to change(Event, :count).by(1)
      end
    end

    context "入力内容に誤りがある場合" do
      it 'リクエストが成功すること' do
        post events_path, params: { event: attributes_for(:event, :invalid) }
        expect(response).to have_http_status(200)
      end

      it "登録が行われないこと" do
        expect do
          post events_path, params: { event: attributes_for(:event, :invalid) }
        end.not_to change(Event, :count)
      end

      it "newテンプレートが表示されること" do
        post events_path, params: { event: attributes_for(:event, :invalid) }
        expect(response).to render_template :new
      end

      it "エラーメッセージが表示されること" do
        post events_path, params: { event: attributes_for(:event, :invalid) }
        expect(assigns(:event).errors.any?).to be_truthy
      end
    end
  end

  describe "GET /index" do
    context "ログインしていない場合" do
      before do
        get events_path
      end

      it "status codeが200となること" do
        expect(response).to have_http_status(200)
      end

      it "indexテンプレートが表示されること" do
        expect(response).to render_template :index
      end

      it "@eventsが取得できていること" do
        expect(assigns(:events)).to eq events.sort.reverse
      end
    end

    context "userでログイン状態の場合" do
      before do
        sign_in user
        get events_path
      end

      it "status codeが200となること" do
        expect(response).to have_http_status(200)
      end

      it "indexテンプレートが表示されること" do
        expect(response).to render_template :index
      end

      it "@eventsが取得できていること" do
        expect(assigns(:events)).to eq events.sort.reverse
      end
    end

    context "protectorでログイン状態の場合" do
      before do
        sign_in protector1
        get events_path
      end

      it "status codeが200となること" do
        expect(response).to have_http_status(200)
      end

      it "indexテンプレートが表示されること" do
        expect(response).to render_template :index
      end

      it "@eventsが取得できていること" do
        expect(assigns(:events)).to eq events.sort.reverse
      end
    end
  end

  describe "GET /edit POST /update" do
    context "protectorがログインしている場合" do
      before do
        sign_in protector1
        event1.save
        event2.save
      end

      it 'リクエストが成功すること' do
        put event_path(event1), params: { event: attributes_for(:event2) }
        expect(response).to have_http_status(302)
      end

      it '入力に誤りがない場合は編集が成功すること' do
        expect do
          put event_path(event1), params: { event: attributes_for(:event2) }
        end.to change { Event.find(event1.id).prefecture }.from('東京都').to('千葉県')
      end

      it "入力が誤っていた場合編集が失敗すること" do
        expect do
          put event_path(event1), params: { event: attributes_for(:event2, :invalid) }
        end.not_to change { Event.find(event1.id).prefecture }
      end

      it "自分以外のpetを編集できないこと" do
        put event_path(event2), params: { event: attributes_for(:event2, :invalid) }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "DELETE /destroy" do
    before do
      sign_in protector1
      event1.save
      event2.save
    end

    it "status codeが302となること" do
      delete event_path(event1)
      expect(response).to have_http_status(302)
    end

    it "削除ができること" do
      expect { delete event_path(event1) }.to change(Event, :count).by(-1)
    end

    it "event/index画面へ遷移すること" do
      delete event_path(event1)
      expect(response).to redirect_to events_path
    end

    it "自分以外のdogを削除できないこと" do
      expect { delete event_path(event2) }.not_to change(Event, :count)
    end
  end
end
