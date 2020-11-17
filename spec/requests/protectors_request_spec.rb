require 'rails_helper'

RSpec.describe "Protectors", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/protectors/show"
      expect(response).to have_http_status(:success)
    end
  end
end
