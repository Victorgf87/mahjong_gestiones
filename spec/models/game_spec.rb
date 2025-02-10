require 'rails_helper'

RSpec.describe Game, type: :model do
  # subject(:game){described_class.create()}
  let(:players) { create_list(:player, 4) }
  let(:user) { create(:user) }

  describe 'associations' do
    let(:tournament) { create(:tournament, creator: user) }
    # let(:league)
    it 'can belong to a tournament' do
      game = create(:game, players:, event: tournament)
      expect(game).to be_valid
      expect(game.event) .to eq(tournament)
    end

    # it 'can belong to a league' do
    #
    # end
  end
end
