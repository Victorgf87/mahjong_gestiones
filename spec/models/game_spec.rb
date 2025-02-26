require 'rails_helper'

RSpec.describe Game, type: :model do
  # subject(:game){described_class.create()}
  let(:players) { create_list(:player, 4) }
  let(:user) { create(:user) }

  let(:tournament) { create(:tournament, creator: user) }
  let(:league) { create(:league, creator: user) }

  describe 'associations' do
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
    [ [ 27, 2, 28, 1 ],
     [ 21, 2, 0, 0 ], [ 14, 28, 27, 0 ], [ 20, 27, 28, 0 ], [ 10, 2, 0, 0 ],
     [ 14, 28, 2, 0 ], [ 12, 28, 1, 0 ], [ 22, 27, 0, 0 ], [ 13, 27, 1, 0 ],
     [ 0, 0, 0, 0 ], [ 9, 28, 27, 0 ], [ 16, 2, 1, 0 ], [ 21, 28, 1, 0 ],
     [ 21, 1, 27, 0 ], [ 11, 27, 1, 0 ], [ 8, 27, 0, 0 ], [ 14, 2, 0, 0 ] ]
  end

  let(:player1) { Player.find_by(player_number: 1) }
  let(:player2) { Player.find_by(player_number: 2) }
  let(:player3) { Player.find_by(player_number: 27) }
  let(:player4) { Player.find_by(player_number: 28) }

  let(:victor) { player1 }
  let(:ye) { player2 }
  let(:elsa) { player3 }
  let(:virginia) { player4 }

  let(:all_players) { [ victor, ye, elsa, virginia ] }

  let(:score_victor) { game.player_score_data(victor) }
  let(:score_ye) { game.player_score_data(ye) }
  let(:score_virginia) { game.player_score_data(virginia) }
  let(:score_elsa) { game.player_score_data(elsa) }
  let(:all_score_data) { [ score_victor, score_ye, score_virginia, score_elsa ].map { OpenStruct.new(_1) } }

  describe 'scoring' do
    let(:game) { Games::CreateFromFileService.new(file_content:, event: league).call }
    before do
      game.fill_scoring
    end

    it 'generates correct changes' do
      expect(game.hands.map { _1.score_changes.sum }.uniq).to eq([ 0 ])
      expected_values = [ [ -29, 87, -29, -29 ], [ -22, -8, 38, -8 ], [ 44, -8, -28, -8 ], [ -18, 54, -18, -18 ],
                         [ -8, -22, 38, -8 ], [ -8, -8, 36, -20 ], [ 90, -30, -30, -30 ], [ 37, -8, -8, -21 ],
                         [ 0, 0, 0, 0 ], [ -17, -8, 33, -8 ], [ -8, 40, -8, -24 ], [ -8, -8, 45, -29 ],
                         [ -29, -8, -8, 45 ], [ 35, -8, -8, -19 ], [ 48, -16, -16, -16 ], [ -22, 66, -22, -22 ] ]
      expect(game.hands.map(&:score_changes)).to match_array(expected_values)
    end

    it 'generates correct current scores' do
      a = 3
      expect(game.hands.map { _1.current_scores.sum }.uniq).to eq([ 0 ])
      expected_values = [ [ -29, 87, -29, -29 ], [ -51, 79, 9, -37 ], [ -7, 71, -19, -45 ], [ -25, 125, -37, -63 ],
                         [ -33, 103, 1, -71 ], [ -41, 95, 37, -91 ], [ 49, 65, 7, -121 ], [ 86, 57, -1, -142 ],
                         [ 86, 57, -1, -142 ], [ 69, 49, 32, -150 ], [ 61, 89, 24, -174 ], [ 53, 81, 69, -203 ],
                         [ 24, 73, 61, -158 ], [ 59, 65, 53, -177 ], [ 107, 49, 37, -193 ], [ 85, 115, 15, -215 ] ]
      expect(game.hands.map(&:current_scores).take(expected_values.count)).to match_array(expected_values)
    end

    it 'generates correct scoring' do
      expect(all_score_data.map(&:score).sum).to eq(0)
      expect(all_score_data.map(&:score)).to eq([ -215, 115, 15, 85 ])

      expect(all_score_data.map(&:position)).to eq([ 4, 1, 3, 2 ])
      # expect(all_score_data.map(&:position_weight).sum).to eq(7) # TODO calculate weight
      # expect(all_score_data.map(&:position_weight)).to eq([4, 1.5, 1.5, 0])
    end
  end

  describe 'score weights' do
    shared_context 'weight calculation' do
      context "when calculating game" do
        let(:game) { Games::CreateFromFileService.new(file_content:, event: league).call }
        before do
          game.fill_scoring
        end

        it 'generates correct weights' do
          expect(all_score_data.map(&:position)).to eq(expected_position)
          expect(all_score_data.map(&:position_weight)).to eq(expected_weights)
        end

        it 'weights sum is correct' do
          expect(all_score_data.map(&:position_weight).sum).to eq(7)
        end
      end
    end

    context 'when it is a tie' do
      include_context 'weight calculation' do
        let(:expected_weights) { [ 1.75, 1.75, 1.75, 1.75 ] }
        let(:expected_position) { [ 1, 1, 1, 1 ] }
        let(:file_content) { [ [ 27, 2, 28, 1 ], [ 0, 0, 0, 0 ] ] }
      end
    end

    context 'when two are first' do
      include_context 'weight calculation' do
        let(:expected_weights) { [ 3, 3, 0.5, 0.5 ] }
        let(:expected_position) { [ 1, 1, 3, 3 ] }
        let(:file_content) { [ [ 27, 2, 28, 1 ], [ 10, 1, 2, 0 ], [ 10, 2, 1, 0 ] ] }
      end
    end

    context 'when two are second' do
      include_context 'weight calculation' do
        let(:expected_weights) { [ 4, 1.5, 1.5, 0.0 ] }
        let(:expected_position) { [ 1, 2, 2, 4 ] }
        let(:file_content) { [ [ 27, 2, 28, 1 ], [ 100, 27, 0, 0 ], [ 10, 2, 27, 0 ], [ 10, 28, 27, 0 ] ] }
      end
    end
  end
  let(:victor_number) { victor.player_number }
  let(:ye_number) { victor.player_number }
  let(:virginia_number) { virginia.player_number }
  let(:elsa_number) { elsa.player_number  }
end
