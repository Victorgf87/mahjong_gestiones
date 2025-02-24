class Hand < ApplicationRecord
  belongs_to :winner, class_name: "Player", foreign_key: :winner_id, optional: true
  belongs_to :loser, class_name:  "Player", foreign_key: :loser_id, optional: true
  belongs_to :game

  # self.implicit_order_column = :position
  # self.implicit_order_column = :position


  def washout?
    !winner.present? && !loser.present?
  end

  def self_drawn?
    winner.present? && !loser.present? && points == 0
  end
end
