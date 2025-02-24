class Image < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  has_one_attached :file
  enum :image_type, { league_cover: 0, user_avatar: 1, general: 2 }

  delegate :attached?, to: :file, prefix: false
end
