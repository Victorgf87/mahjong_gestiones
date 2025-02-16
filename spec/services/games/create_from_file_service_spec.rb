# frozen_string_literal: true

require 'rails_helper'

describe Games::CreateFromFileService do
  let(:file_content) do
    [[27, 2, 28, 1], [21, 2, 0, 0], [14, 1, 27, 0], [20, 27, 28, 0], [10, 2, 0, 0], [14, 28, 2, 0], [12, 28, 1, 0],
     [22, 27, 0, 0], [13, 27, 1, 0], [0, 0, 0, 0], [9, 28, 27, 0], [16, 1, 2, 0], [21, 28, 1, 0], [21, 1, 27, 0],
     [11, 27, 1, 0], [8, 27, 0, 0], [14, 2, 0, 0]]
  end

  let(:event) { League.first }

  let(:all_players) { [player1, player2, player3, player4] }

  let(:player1) { Player.find_by(player_number: 1) }
  let(:player2) { Player.find_by(player_number: 2) }
  let(:player3) { Player.find_by(player_number: 27) }
  let(:player4) { Player.find_by(player_number: 28) }

  describe 'creation' do
    subject(:created_game) { described_class.new(file_content:, event:).call }

    it 'has correct amount of hands' do
      expect(created_game.reload.hands.count).to eq(16)
    end

    it 'has correct number of players' do
      expect(created_game.reload.players.count).to eq(4)
    end

    it 'creates game with players seated where they have to be' do
      expect(created_game).to be_persisted
      expect(GamePlayer.find_by(player_id: player3, seat: 'east')).to be_present
      expect(GamePlayer.find_by(player_id: player2, seat: 'south')).to be_present
      expect(GamePlayer.find_by(player_id: player4, seat: 'west')).to be_present
      expect(GamePlayer.find_by(player_id: player1, seat: 'north')).to be_present
    end
  end
end
