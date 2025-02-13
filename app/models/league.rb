class League < ApplicationRecord
  include Imageable
  include Updatable
  include Gameable


  has_many :photos, as: :imageable, dependent: :destroy
end
