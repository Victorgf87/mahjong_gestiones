require 'rails_helper'

RSpec.describe Game, type: :model do
  # subject(:game){described_class.create()}
  let(:players) { create_list(:player, 4) }
  let(:user) { create(:user) }

  let(:tournament) { create(:tournament, creator: user) }
  let(:league) { create(:league, creator: user) }

  describe 'associations' do

    # let(:league)
    it 'can belong to a tournament' do
      game = create(:game, players:, event: tournament)
      expect(game).to be_valid
      expect(game.event).to eq(tournament)
    end

    it 'can belong to a league' do
      game = create(:game, players:, event: league)
      expect(game).to be_valid
      expect(game.event).to eq(league)
    end
  end

  describe 'players' do
    it 'can have players' do
      game = create(:game, players: players)
      expect(game.players).to eq(players)
    end

    it 'can have players with seats' do
      game = create(:game, players: players)
      game.assign_seat_to_player(players[0], 1)
      game.assign_seat_to_player(players[1], 2)
      game.assign_seat_to_player(players[2], 3)
      game.assign_seat_to_player(players[3], 4)

      expect(game.east_player).to eq(players[0])
      expect(game.south_player).to eq(players[1])
      expect(game.west_player).to eq(players[2])
      expect(game.north_player).to eq(players[3])
    end
  end

  let(:file_content) do
    [[27, 2, 28, 1], [21, 2, 0, 0], [14, 1, 27, 0], [20, 27, 28, 0], [10, 2, 0, 0], [14, 28, 2, 0], [12, 28, 1, 0],
     [22, 27, 0, 0], [13, 27, 1, 0], [0, 0, 0, 0], [9, 28, 27, 0], [16, 1, 2, 0], [21, 28, 1, 0], [21, 1, 27, 0],
     [11, 27, 1, 0], [8, 27, 0, 0], [14, 2, 0, 0]]
  end

  let(:all_players) { [player1, player2, player3, player4] }

  let(:player1) { Player.find_by(player_number: 1) }
  let(:player2) { Player.find_by(player_number: 2) }
  let(:player3) { Player.find_by(player_number: 27) }
  let(:player4) { Player.find_by(player_number: 28) }


  describe 'scoring' do
    it 'generates correct scoring' do
      game = Games::CreateFromFileService.new(file_content:, event: league).call

      game.fill_scoring

      score_1 = game.player_score_data(all_players[0])
      score_2 = game.player_score_data(all_players[1])
      score_3 = game.player_score_data(all_players[2])
      score_4 = game.player_score_data(all_players[3])

      all_score_data = [score_1, score_2, score_3, score_4].map { OpenStruct.new(_1) }

      expect(all_score_data.map(&:score).sum).to eq(0)
      expect(all_score_data.map(&:score)).to eq([85, 115, 15, -215])

      expect(all_score_data.map(&:position)).to eq([1, 4, 3, 2])
      # expect(all_score_data.map(&:position_weight).sum).to eq(7) # TODO calculate weight
      # expect(all_score_data.map(&:position_weight)).to eq([4, 1.5, 1.5, 0])
    end
  end
end
