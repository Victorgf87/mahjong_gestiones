class Player < ApplicationRecord

  has_many :event_players, dependent: :destroy
  has_many :tournaments, through: :event_players, source: :eventable, source_type: 'Tournament'
  has_many :leagues, through: :event_players, source: :eventable, source_type: 'League'


  belongs_to :user, optional: true
end
