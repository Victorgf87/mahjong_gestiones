class Game < ApplicationRecord
  belongs_to :event, polymorphic: true
  has_many :game_players, dependent: :destroy
  has_many :players, through: :game_players
  enum :game_type, { mcr: 0, riichi: 1}

  def rated?
    event.present? ? true : self.rated
  end
end
