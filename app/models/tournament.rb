class Tournament < ApplicationRecord
  has_many :players
  validates :name, presence: true

  has_many :tournament_players
  has_many :players, through: :tournament_players
end
