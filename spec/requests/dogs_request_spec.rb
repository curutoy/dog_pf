require 'rails_helper'

RSpec.describe "Dogs", type: :request do
  let!(:user)      { create(:user) }
  let!(:protector) { create(:protector) }
  let!(:protector2) { create(:protector2) }
  let!(:dog1) { build(:dog, protector_id: protector.id) }
  let!(:dog2) { build(:dog, protector_id: protector2.id) }
  let!(:dogs) { build_list(:dog, 2, protector_id: protector.id) }
  let!(:posts) { build_list(:post, 2) }

  describe "GET /new" do
    context "ログインしていない場合" do
      before do
        get new_dog_path
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
        get new_dog_path
      end

      it "302レスポンスを返すこと" do
        expect(response).to have_http_status(302)
      end

      it "indexへリダイレクトされること" do
        expect(response).to redirect_to root_path
      end
    end

    context "protectorでログイン状態の場合" do
      before do
        sign_in protector2
        get new_dog_path
      end

      it "リクエストが成功すること" do
        expect(response).to have_http_status(200)
      end

      it "newテンプレートが表示されること" do
        expect(response).to render_template :new
      end
    end
  end

  describe "Post /create" do
    before do
      sign_in protector2
    end

    context "入力内容に誤りがない場合" do
      it 'リクエストが成功すること' do
        post dogs_path, params: { dog: attributes_for(:dog2) }
        expect(response).to have_http_status(302)
      end

      it "投稿が成功すること" do
        expect do
          post dogs_path, params: { dog: attributes_for(:dog2) }
        end.to change(Dog, :count).by(1)
      end
    end

    context "入力内容に誤りがある場合" do
      it 'リクエストが成功すること' do
        post dogs_path, params: { dog: attributes_for(:dog2, :invalid) }
        expect(response).to have_http_status(200)
      end

      it "登録が行われないこと" do
        expect do
          post dogs_path, params: { dog: attributes_for(:dog2, :invalid) }
        end.not_to change(Dog, :count)
      end

      it "newテンプレートが表示されること" do
        post dogs_path, params: { dog: attributes_for(:dog2, :invalid) }
        expect(response).to render_template :new
      end

      it "エラーメッセージが表示されること" do
        post dogs_path, params: { dog: attributes_for(:dog2, :invalid) }
        expect(assigns(:dog).errors.any?).to be_truthy
      end
    end
  end

  describe "GET /show" do
    before do
      dog1.image = fixture_file_upload("/files/test.png")
      dog1.save
      posts.each do |post|
        post.image = fixture_file_upload("/files/test.png")
        post.dog_id = dog1.id
        post.save
      end
    end

    context "ログインしていない場合" do
      before do
        get dog_path dog1
      end

      it "リクエストはエラーが発生すること" do
        expect(response).to have_http_status(302)
      end

      it "ホーム画面にリダイレクトされること" do
        expect(response).to redirect_to root_path
      end
    end

    context "userでログイン状態の場合" do
      before do
        sign_in user
        get dog_path dog1
      end

      it "リクエストが成功すること" do
        expect(response).to have_http_status(200)
      end

      it "showテンプレートが表示されること" do
        expect(response).to render_template :show
      end

      it "@dogが取得できていること" do
        expect(assigns(:dog)).to eq dog1
      end

      it "@postsが取得できていること" do
        expect(assigns(:posts)).to eq posts
      end
    end

    context "protectorでログイン状態の場合" do
      before do
        sign_in protector2
        get dog_path dog1
      end

      it "リクエストが成功すること" do
        expect(response).to have_http_status(200)
      end

      it "showテンプレートが表示されること" do
        expect(response).to render_template :show
      end

      it "@dogsが取得できていること" do
        expect(assigns(:dog)).to eq dog1
      end

      it "@postsが取得できていること" do
        expect(assigns(:posts)).to eq posts
      end
    end
  end

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
        dogs.each do |dog|
          dog.image = fixture_file_upload("/files/test.png")
          dog.save
        end
        sign_in user
        get root_path
      end

      it "リクエストが成功すること" do
        expect(response).to have_http_status(200)
      end

      it "indexテンプレートが表示されること" do
        expect(response).to render_template :index
      end

      it "@dogsが取得できていること" do
        expect(assigns(:dogs)).to eq dogs
      end
    end

    context "protectorでログイン状態の場合" do
      before do
        dogs.each do |dog|
          dog.image = fixture_file_upload("/files/test.png")
          dog.save
        end
        sign_in protector2
        get root_path
      end

      it "リクエストが成功すること" do
        expect(response).to have_http_status(200)
      end

      it "indexテンプレートが表示されること" do
        expect(response).to render_template :index
      end

      it "@dogsが取得できていること" do
        expect(assigns(:dogs)).to eq dogs
      end
    end
  end

  describe "GET /edit" do
    before do
      dog1.image = fixture_file_upload("/files/test.png")
      dog1.save
      dog2.image = fixture_file_upload("/files/test.png")
      dog2.save
    end

    context "ログインしていない場合" do
      before do
        get edit_dog_path dog1
      end

      it "302レスポンスを返すこと" do
        expect(response).to have_http_status(302)
      end

      it "indexへリダイレクトされること" do
        expect(response).to redirect_to root_path
      end
    end

    context "userでログイン状態の場合" do
      before do
        sign_in user
        get edit_dog_path dog1
      end

      it "302レスポンスを返すこと" do
        expect(response).to have_http_status(302)
      end

      it "indexへリダイレクトされること" do
        expect(response).to redirect_to root_path
      end
    end

    context "protectorでログイン状態の場合" do
      before do
        sign_in protector
      end

      context "自身の登録したdog以外にアクセスする場合" do
        before do
          get edit_dog_path dog2
        end

        it "302レスポンスを返すこと" do
          expect(response).to have_http_status(302)
        end

        it "indexへリダイレクトされること" do
          expect(response).to redirect_to root_path
        end
      end

      context "自身で登録したdogにアクセスする場合" do
        before do
          get edit_dog_path dog1
        end

        it "リクエストは成功すること" do
          expect(response).to have_http_status(200)
        end

        it "editテンプレートが表示されること" do
          expect(response).to render_template :edit
        end

        it "@dogが取得できていること" do
          expect(assigns(:dog)).to eq dog1
        end
      end
    end
  end
end
