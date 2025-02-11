class Game < ApplicationRecord
  belongs_to :event, polymorphic: true
  has_many :game_players, dependent: :destroy
  has_many :players, through: :game_players
  enum :game_type, { mcr: 0, riichi: 1 }
  enum :status, { pending: 0, progress: 1, finished: 2 }
  has_many :hands
  attr_accessor :final_scores, :player_

  def rated?
    event.present? ? true : self.rated
  end

  def generate_full_game
    hands_rows = hands.map do |hand|
      current_hand_score(hand)
    end

    final_scores = hands_rows.pluck(:changes).transpose.map(&:sum)
    final_scores = players.map(&:full_name).zip(final_scores).to_h.sort_by { |_, valor| -valor }.to_h
    a = 3
    {
      hands: hands_rows,
      results: final_scores
    }
  end

  def current_hand_score(hand)

    self_drawn = !hand.loser.present?
    winner_value = if self_drawn
                     3 * hand.points + 24
                   else
                     hand.points + 24
                   end

    changes = players.map do |player|
      if player == hand.winner
        winner_value
      else
        if self_drawn || hand.loser == player
          (hand.points * -1) - hand.points
        else
          -8
        end
      end
    end

    {
      winner: hand.winner.full_name,
      loser: hand.loser&.full_name || 'Self',
      changes:
    }
  end
end
