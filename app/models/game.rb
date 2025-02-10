class Game < ApplicationRecord
  belongs_to :tournament
  has_many :game_players, dependent: :destroy
  has_many :players, through: :game_players
end
