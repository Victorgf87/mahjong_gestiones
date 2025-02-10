class LeaguesController < ApplicationController
  def new
    @league = League.new
  end

  def create
    @league = League.new(league_params)
    if @league.save
      redirect_to @league, notice: 'Liga creada exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def league_params
    params.require(:league).permit(:name, :start_date, :cover_image)
  end
end
