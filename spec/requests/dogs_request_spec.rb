require 'rails_helper'

RSpec.describe "Dogs", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/dogs/index"
      expect(response).to have_http_status(:success)
    end
  end
end
