class Image < ApplicationRecord
  belongs_to :imageable, polymorphic: true

  enum :image_type, { league_cover: 0, user_avatar: 1, general: 2 }
end
