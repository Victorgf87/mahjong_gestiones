class Hand < ApplicationRecord
  belongs_to :winner, class_name: "Player", foreign_key: :winner_id, optional: true
  belongs_to :loser, class_name:  "Player", foreign_key: :loser_id, optional: true
  belongs_to :game

  def washout?
    !winner.present? && !loser.present?
  end
end
