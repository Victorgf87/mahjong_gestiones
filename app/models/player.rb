class Player < ApplicationRecord
  has_many :tournament_players, dependent: :destroy
  has_many :tournaments, through: :tournament_players
end
