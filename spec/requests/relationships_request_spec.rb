require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  let!(:protector)    { create(:protector) }
  let!(:user)         { create(:user) }
  let(:relationship)  { build(:relationship, protector: protector, user: user) }
  let(:relationship2) { build(:relationship, protector: protector, user: user) }

  describe "POST /create" do
    context "userがログインしている場合" do
      before do
        sign_in user
      end

      it "リクエストが成功すること" do
        post relationships_path, params: { protector_id: protector.id }
        expect(response).to have_http_status(302)
      end

      it "フォローが成功すること" do
        expect do
          post relationships_path, params: { protector_id: protector.id }
        end.to change(Relationship, :count).by(1)
      end

      it "protector画面へリダイレクトすること" do
        post relationships_path, params: { protector_id: protector.id }
        expect(response).to redirect_to protector_path(protector)
      end
    end
  end

  describe "DELETE /destroy" do
    context "protectorがログインしている場合" do
      before do
        sign_in user
        relationship.save
      end

      it "リクエストが成功すること" do
        delete relationship_path(id: relationship.id)
        expect(response).to have_http_status(302)
      end

      it "フォロー解除ができること" do
        expect { delete relationship_path(id: relationship.id) }.to change(Relationship, :count).by(-1)
      end

      it "protector画面へリダイレクトすること" do
        delete relationship_path(id: relationship.id)
        expect(response).to redirect_to protector_path(protector)
      end
    end
  end
end
