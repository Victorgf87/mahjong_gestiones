class LeaguesController < ApplicationController
  def index
    @leagues = League.all
  end
  def new
    @league = League.new
    @league.build_cover_image
  end

  def show
    @league = League.find(params[:id])
  end

  def create
    @league = League.new(league_params.merge(creator: current_user))
    if @league.save
      redirect_to @league, notice: "Liga creada exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def league_params
    params.require(:league).permit(:name, :description, :start_date, :end_date, cover_image_attributes: [ :image_type, :file ])
  end
end
