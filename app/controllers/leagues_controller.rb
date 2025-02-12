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
    # @league.build_cover_image(image_params)
    if @league.save
      redirect_to @league, notice: "Liga creada exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def league_params
    params.require(:league).permit(:name, :description, :start_date, cover_image_attributes: [ :image_type, :file ])
  end

  def image_params
    params.require(:image).permit(:file, :image_type)
  end
end
