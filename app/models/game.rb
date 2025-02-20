class Game < ApplicationRecord
  belongs_to :event, polymorphic: true, optional: true
  has_many :game_players, dependent: :destroy
  has_many :players, through: :game_players
  enum :game_type, { mcr: 0, riichi: 1 }
  enum :status, { pending: 0, progress: 1, finished: 2 }
  has_many :hands, dependent: :destroy
  accepts_nested_attributes_for :hands, reject_if: lambda { |attributes| attributes['points'].blank? }, allow_destroy: true
  attr_accessor :final_scores, :player_

  def rated?
    event.present? ? true : self.rated
  end

  %w[east south west north].each_with_index do |seat, index|
    define_method("#{seat}_player") do
      game_players.find_by(seat:)&.player
    end
  end

  def assign_seat_to_player(player, seat)
    game_players.find_by(player: player).update(seat: seat)
  end

  def all_scores
    game_players.map { |game_player| player_score_data(game_player.player) }
  end

  def players_by_scores
    game_players.order(score: :desc).pluck(:player_id)
  end

  def player_score_data(player)
    game_player = game_players.find_by(player: player)
    {
      player_id: player.id,
      name: player.full_name,
      score: game_player.score,
      position: game_player.position,
      position_weight: game_player.position_weight,
      seat: game_player.seat
    }
  end

  def sorted_players
    # @sorted_players ||= players.joins(:game_players).where(game_players: game_id: id).order('game_players.seat')
    @sorted_players ||= players.joins(:game_players)
                               .where(game_players: { game_id: id })
                               .select("players.*, game_players.seat")
                               .order("game_players.seat").uniq
  end

  def sorted_game_players
    @sorted_game_players ||= game_players.in_order_of(:seat, %w[east south west north])
  end

  def fill_scoring
    current_scores = [0, 0, 0, 0]
    hands.order(:position).each_with_index do |hand, index|
      raise "nope" unless hand.position == (index + 1)
      if hand.winner
        self_drawn = !hand.loser.present?
        winner_value = if self_drawn
                         3 * hand.points + 24
                       else
                         hand.points + 24
                       end

        score_changes = sorted_players.map do |player|
          if player == hand.winner
            winner_value
          elsif player == hand.loser
            -8 - hand.points
          else
            -8 - (self_drawn ? hand.points : 0)
          end
        end
      else
        score_changes = [0, 0, 0, 0]
      end

      current_scores = current_scores.zip(score_changes).map(&:sum)
      hand.update!(score_changes: score_changes, current_scores: current_scores)
    end

    final_game_players = sorted_game_players.zip(current_scores)
                                            .sort_by { |jugador, puntos| -puntos }
                                            .map(&:first)

    sorted_game_players.each_with_index do |game_player, index|
      score = current_scores[index]
      position = final_game_players.map(&:player).index(game_player.player) + 1
      game_player.update(score:, position:)
    end

    assign_weights
    assign_positions
  end

  def score_repetitions
    game_players.select(:score).group(:score).count
  end

  def assign_positions
    weight_position = {
      3.0 => 1,
      0.0 => 4,
      1.75 => 1,
      1.5 => 2,
      4.0 => 1,
      2.0 => 2,
      1.0 => 3,
      0.5 => 3
    }
    game_players.each do |game_player|
      game_player.update!(position: weight_position[game_player.position_weight])
    end
  end

  def assign_weights
    sorted_game_players = game_players.order(score: :asc)
    array = sorted_game_players.pluck(:score)

    sorted = array.sort.reverse

    puntos_base = [4, 2, 1, 0]
    resultado = {}
    posicion_actual = 0

    sorted.each_with_index do |valor, index|
      if index == 0 || valor != sorted[index - 1]
        posicion_actual = index
      end

      count = sorted.count(valor)
      puntos_asignados = puntos_base[posicion_actual, count].sum.to_f / count
      resultado[valor] = puntos_asignados.round(2)
    end

    mapped_results = array.map { |valor| resultado[valor] }

    mapped_results.each_with_index do |weight, index|
      sorted_game_players[index].update!(position_weight: weight)
    end

    # initial_points = [4, 2, 1, 0]
    # initial_points = {
    #   4 => 0,
    #   3 => 1,
    #   2 => 2,
    #   1 => 4
    # }
    #
    # values = { 4 => 0, 3 => 1, 2 => 2, 1 => 4 }
    #
    # game_players_sorted_by_score = game_players.order(score: :desc)
    # score_values = game_players_sorted_by_score.pluck(:score)
    #
    # # weight_to_assign = initial_points[position] / score_repetitions[game_player.score]
    #
    # game_players_sorted_by_score.each_with_index do |game_player|
    #
    # end
    #
    #
    #
    # game_players_sorted_by_score.each(&:save!)
    #
    # # game_players_sorted_by_score.each_with_index do |game_player, index|
    # #   position = index + 1
    # #
    # #   unless index==0
    # #     if
    # #   end
    # #
    # #   weight_to_assign = initial_points[position] / score_repetitions[game_player.score]
    # #
    # #   game_player.update(position_weight: weight_to_assign, position:)
    # # end
  end

  def generate_full_game
    hands_rows = hands.map do |hand|
      current_hand_score(hand)
    end

    final_scores = hands_rows.pluck(:changes).transpose.map(&:sum)
    final_scores = players.map(&:full_name).zip(final_scores).to_h.sort_by { |_, valor| -valor }.to_h

    ret = {
      hands: hands_rows,
      results: final_scores,
      players: players.map(&:full_name)
    }
    ret
  end

  # TODO Test empate case

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
        -8 - (self_drawn ? hand.points : 0)
      end
    end

    {
      winner: hand.winner.full_name,
      loser: hand.loser&.full_name || "All",
      points: hand.points,
      changes:
    }
  end
end
