require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let!(:protector) { create(:protector2) }
  let!(:dog)       { create(:dog2, protector: protector) }
  let!(:delete_post) { build(:post2, dog: dog) }

  describe "POST /create" do
    context "protectorがログインしている場合" do
      before do
        sign_in protector
      end

      it 'リクエストが成功すること' do
        post dog_posts_path(dog_id: dog.id), params: { post: attributes_for(:post2) }
        expect(response).to have_http_status(302)
      end

      it '入力に誤りがない場合は投稿が成功すること' do
        expect do
          post dog_posts_path(dog_id: dog.id), params: { post: attributes_for(:post2) }
        end.to change(Post, :count).by(1)
      end

      it "入力が誤っていた場合投稿が失敗すること" do
        expect do
          post dog_posts_path(dog_id: dog.id), params: { post: {
            dog_id: dog.id,
            content: "a" * 201,
            image: Rack::Test::UploadedFile.new(File.join(Rails.root, "spec/fixtures/files/test.png"), 'image/png'),
          } }
        end.not_to change(Post, :count)
      end
    end
  end

  describe "DELETE /destroy" do
    context "protectorがログインしている場合" do
      before do
        sign_in protector
        delete_post.save
      end

      it "リクエストが成功すること" do
        delete dog_post_path(dog_id: dog.id, id: delete_post.id)
        expect(response).to have_http_status(302)
      end

      it "削除ができること" do
        expect { delete dog_post_path(dog_id: dog.id, id: delete_post.id) }.to change(Post, :count).by(-1)
      end

      it "dog詳細画面へリダイレクトすること" do
        delete dog_post_path(dog_id: dog.id, id: delete_post.id)
        expect(response).to redirect_to dog_path(dog)
      end
    end
  end
end
