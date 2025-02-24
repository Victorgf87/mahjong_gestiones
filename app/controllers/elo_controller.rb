class EloController < ApplicationController
  def show
    @elo_data = Rankings::EloCalculationService.new.call(Game.all)
  end
end
