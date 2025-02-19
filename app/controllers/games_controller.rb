class GamesController < ApplicationController
  before_action :set_game, only: [ :show, :edit, :update ]

  def set_game
    @game = Game.find(params[:id])
  end
  def index
  end


  def show
    @game = Game.find(params[:id])
    @game.fill_scoring unless @game.finished?
    @scores = @game.all_scores.map { OpenStruct.new(_1) }
    @statistics = Statistics::GameStatisticsService.new(@game).call

    @data = {
      "Rojo" => 30,
      "Azul" => 50,
      "Amarillo" => 20
    }

  end

  layout 'nostyle'

  def edit
    if @game.finished?
      flash.alert = t("translations.success")
      redirect_to action: :show
    end
    @game = Game.find(params[:id])
    @game_players = @game.players
    @new_hand = @game.hands.new(position: @game.hands.count + 1)
  end

  def update
    @game.update!(game_params)
    @game.fill_scoring unless @game.finished?
    @game.reload
  end


  def create_hand
    a = 3
  end


  def game_params
    params.require(:game).permit(:game_attributes, hands_attributes: [ :id, :position, :points, :winner_id, :loser_id, :hand_attributes, :_destroy ])
  end
end
