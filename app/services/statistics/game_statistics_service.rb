module Statistics
  class GameStatisticsService
    attr_reader :game

    def initialize(game)
      @game = game
      @ids_names = game.players.pluck(:id, :name).to_h
    end

    def call
      @game.fill_scoring unless @game.finished?
      {
        washouts:,
        walls:,
        dealt_times:,
        highest_scores:,
        score_times:,
        score_distribution:
      }
    end

    private

    def washouts
      hands.where(points: 0).count
    end

    def score_distribution
      # Obtener el conteo agrupado por puntos
      grouped_counts = hands.where.not(loser_id: nil).group(:points).count

      # Calcular el total de manos
      total_count = grouped_counts.values.sum

      # Calcular el porcentaje para cada valor de puntos
      percentages = grouped_counts.transform_values do |count|
        (count.to_f / total_count * 100).round(2)
      end

      sort_hash(percentages)
    end

    def sort_hash(hash)
      hash.sort_by { |key, _| key.to_i }.to_h
    end

    def score_times
      scores = hands.where.not(loser_id: nil).pluck(:points)
      sort_hash(scores.group_by(&:itself).transform_values(&:count))
    end

    def highest_scores
      max_points = hands.maximum(:points)
      hands_with_max_points = hands.where(points: max_points).pluck(:winner_id, :points).to_h
      hands_with_max_points.transform_keys { |id| @ids_names[id] }
    end

    def hands
      @hands ||= @game.hands
    end

    # TODO: Awards, like most tsumos, most riichis, most wins, etc. Most fanegas...

    def dealt_times
      dealt_hands = hands.where.not(loser_id: nil)
      player_dealt_times = dealt_hands.group(:loser_id).count
      {
        total: dealt_hands.count
      }.merge(player_dealt_times.transform_keys { |id| @ids_names[id] })
    end

    def walls
      player_tsumos = hands.where.not(winner:nil).where(loser: nil)
      tsumo_data = player_tsumos.group(:winner_id)
      {
        total: player_tsumos.count
      }.merge(tsumo_data.count.transform_keys { |id| @ids_names[id] })
    end
  end
end
