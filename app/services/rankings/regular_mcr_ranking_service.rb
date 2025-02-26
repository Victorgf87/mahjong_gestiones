class Rankings::RegularMcrRankingService
  attr_accessor :games

  def initialize(games)
    @games = games
  end

  def call
    game_players = GamePlayer.where(game_id: games.pluck(:id))
    grouped_players = game_players.group(:player_id)
    scores = grouped_players.sum(:score)
    points = grouped_players.sum(:position_weight)

    ret = (scores.map { |key, value| { "#{Player.find(key).full_name}": { minipoints: value, table_points: points[key] } } }.inject(&:merge).presence || {})

    ret = ret.sort_by { |_, v| [ v[:table_points], v[:minipoints] ] }.reverse.to_h


    ret
  end
end
