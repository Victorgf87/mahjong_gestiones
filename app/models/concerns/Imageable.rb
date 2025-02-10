module Imageable
  extend ActiveSupport::Concern

  included do
    has_many :images, as: :imageable, dependent: :destroy
  end

  # has_one :cover_image, -> { where(cover: true) }, as: :imageable, class_name: 'Image'
  # has_many :images, -> { where(cover: false) }, as: :imageable, class_name: 'Image'

  def image_url
    images.first.try(:image).try(:url)
  end
end