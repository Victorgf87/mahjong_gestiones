class League < ApplicationRecord
  include Imageable
  include Updatable

  has_many :event_players, as: :eventable, dependent: :destroy
  has_many :players, through: :event_players
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  has_many :photos, as: :imageable, dependent: :destroy
end
