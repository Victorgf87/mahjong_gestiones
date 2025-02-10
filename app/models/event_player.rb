class EventPlayer < ApplicationRecord
  belongs_to :player
  belongs_to :eventable, polymorphic: true
end
