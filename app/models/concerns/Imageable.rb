module Imageable
  extend ActiveSupport::Concern

  included do
    has_many :images, as: :imageable, class_name: "Image", dependent: :nullify
    has_one :cover_image, as: :imageable, class_name: "Image", dependent: :nullify
    accepts_nested_attributes_for :cover_image, allow_destroy: true
    accepts_nested_attributes_for :images
  end

  # has_one :cover_image, -> { where(cover: true) }, as: :imageable, class_name: 'Image'
  # has_many :images, -> { where(cover: false) }, as: :imageable, class_name: 'Image'

  def image_url
    images.first.try(:image).try(:url)
  end
end
