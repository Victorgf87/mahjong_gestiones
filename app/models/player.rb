class Player < ApplicationRecord
  has_many :event_players, dependent: :destroy
  has_many :tournaments, through: :event_players, source: :eventable, source_type: "Tournament"
  has_many :leagues, through: :event_players, source: :eventable, source_type: "League"

  validates :player_number, presence: true, uniqueness: true

  before_validation :set_player_number

  def set_player_number
    player_number ||= 0
    return unless player_number&.zero?
    self.player_number = Player.maximum(:player_number) + 1
  end


  belongs_to :user, optional: true

  def full_name
    "#{name} #{surname}"
  end
end