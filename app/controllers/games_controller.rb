class GamesController < ApplicationController
  def index
  end

  def show
    @game = Game.find(params[:id])
    @game.fill_scoring unless @game.finished?
    @scores = @game.all_scores.map{OpenStruct.new(_1)}
    @statistics = Statistics::GameStatisticsService.new(@game).call
  end
end
