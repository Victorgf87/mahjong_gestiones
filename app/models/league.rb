class League < ApplicationRecord
  has_many :event_players, as: :eventable, dependent: :destroy
  has_many :players, through: :event_players
end
