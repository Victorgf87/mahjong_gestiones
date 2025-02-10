class Tournament < ApplicationRecord
  has_many :players
  validates :name, presence: true

  geocoded_by :location_address
  after_validation :geocode

  has_many :tournament_players
  has_many :players, through: :tournament_players

  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'

  enum :status, { draft: 0, ready: 1, progress: 2, finished: 3 }
  has_many :rounds

  validates :status, presence: true

  STATUS_COLORS = {
    'draft': 'yellow',
    'ready': 'green',
    'progress': 'blue',
    'finished': 'red'
  }.freeze

  def status_color
    STATUS_COLORS[status.to_sym]
  end


  def generate_pairings
    result = SupabasePairingsService.new(players, rounds).call
    a = 3


  end
end
