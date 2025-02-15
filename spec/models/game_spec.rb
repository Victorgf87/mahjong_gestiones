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
      expect(game.event).to eq(tournament)
    end

    it 'generates correct scoring' do
      game = create(:game, players: players)

      create(:hand, game: game, winner: players[0], loser: players[1], points: 10)
      create(:hand, game: game, winner: players[0], loser: players[2], points: 8)
      create(:hand, game: game, winner: players[3], points: 12)

      game.fill_scoring

      # score_1 = game.game_players.find_by(player: players[0]).score
      # score_2 = game.game_players.find_by(player: players[1]).score
      # score_3 = game.game_players.find_by(player: players[2]).score
      # score_4 = game.game_players.find_by(player: players[3]).score
      score_1 = game.player_score_data(players[0])
      score_2 = game.player_score_data(players[1])
      score_3 = game.player_score_data(players[2])
      score_4 = game.player_score_data(players[3])

      all_score_data = [score_1, score_2, score_3, score_4].map { OpenStruct.new(_1) }

      expect(all_score_data.map(&:score).sum).to eq(0)
      expect(all_score_data.map(&:score)).to eq([46, -46, -44, 44])

      expect(all_score_data.map(&:position)).to eq([1, 4, 3, 2])
      expect(all_score_data.map(&:position_weight).sum).to eq(7)
      expect(all_score_data.map(&:position_weight)).to eq([4, 1.5, 1.5, 0])

    end

    # it 'can belong to a league' do
    #
    # end
  end
end
