# frozen_string_literal: true

require 'rails_helper'

describe Rankings::RegularMcrRankingService do
  subject(:result) { described_class.new(games).call }

  let(:players) { create_list(:player, 12) }


  # #<GamePlayer:0x00007d31feee09c8
  #  id: "073f616a-a6e5-4c18-95d6-d6957f72d41a",
  #  player_id: "9716462c-804b-4847-832d-7a253cdd2ed2",
  #  game_id: "427c1c37-e84c-46f7-9fe4-85cf092b4acb",
  #  created_at: "2025-02-18 11:21:12.209301000 +0000",
  #  updated_at: "2025-02-18 11:21:12.563814000 +0000",
  #  score: 85,
  #  position: 2,
  #  position_weight: 2.0,
  #  seat: "east">

  context 'when there are tied players' do
    let!(:games) {
      game_ids = []
      game_1 = create(:game)
      game_1.game_players.create(player: players[0], position_weight: 4, score: 100, seat: 'east')
      game_1.game_players.create(player: players[1], position_weight: 2, score: 50, seat: 'south')
      game_1.game_players.create(player: players[2], position_weight: 1, score: -50, seat: 'west')
      game_1.game_players.create(player: players[3], position_weight: 0, score: -100, seat: 'north')
      game_ids << game_1.id

      game_2 = create(:game)
      game_2.game_players.create(player: players[4], position_weight: 4, score: 101, seat: 'east')
      game_2.game_players.create(player: players[5], position_weight: 2, score: 51, seat: 'south')
      game_2.game_players.create(player: players[6], position_weight: 1, score: -51, seat: 'west')
      game_2.game_players.create(player: players[7], position_weight: 0, score: -101, seat: 'north')
      game_ids << game_2.id

      Game.where(id: game_ids)
    }

    it 'succeeds' do
      result
    end
  end
end
