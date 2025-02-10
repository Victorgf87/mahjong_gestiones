class Player < ApplicationRecord
  has_many :tournament_players, dependent: :destroy
  has_many :tournaments, through: :tournament_players
  belongs_to :user, optional: true
end
