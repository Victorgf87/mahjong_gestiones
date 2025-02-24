require 'rails_helper'

RSpec.describe "Mains", type: :request do
  describe "GET /index" do
    it "returns http success" do
      pending "Implement something"
      get "/main/index"
      expect(response).to have_http_status(:success)
    end
  end
end
