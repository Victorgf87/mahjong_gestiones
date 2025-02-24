require 'rails_helper'

RSpec.describe "Games", type: :request do
  let(:user) { User.first }
  before do
    sign_in user
  end
  describe "GET /index" do
    it "returns http success" do
      get "/games"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    let(:players) { create_list(:player, 4) }
    let(:game) { create(:game, players:) }

    it "returns http success" do
      get "/games/#{game.id}"
      expect(response).to have_http_status(:success)
    end
  end
end
