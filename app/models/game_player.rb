class GamePlayer < ApplicationRecord
  belongs_to :player
  belongs_to :game

  enum :seat, { none: -1, east: 1, south: 2, west: 3, north: 4 }, prefix: true

  # TODO adapt game card to use seats
end

# seats_values = {0 => 'east', 1 => 'south', 2 => 'west', 3=> 'north'}
#
#
# league_games.each do |game|
#   game.game_players.each_with_index do|game_player, index|
#     game_player.update!(seat: seats_values[index])
#   end
# end
