class Photo < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  validates :file_key, presence: true
end
