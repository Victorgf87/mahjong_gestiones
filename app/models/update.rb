class Update < ApplicationRecord
  belongs_to :updatable, polymorphic: true
end
