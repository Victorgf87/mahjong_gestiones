class Tournament < ApplicationRecord
  has_many :players
  validates :name, presence: true

  has_many :tournament_players
  has_many :players, through: :tournament_players

  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'

  enum :status, { draft: 0, ready: 1, progress: 2, finished: 3 }

  validates :status, presence: true
end
