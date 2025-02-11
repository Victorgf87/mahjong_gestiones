module Updatable
  extend ActiveSupport::Concern

  included do
    has_many :updates, as: :updatable
  end
end
