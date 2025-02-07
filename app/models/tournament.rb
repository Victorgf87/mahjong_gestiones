class Tournament < ApplicationRecord
  has_many :players
  validates :name, presence: true

  has_many :tournament_players
  has_many :players, through: :tournament_players

  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
end
