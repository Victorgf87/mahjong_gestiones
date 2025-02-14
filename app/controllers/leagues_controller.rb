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

  def edit
    @league = League.find(params[:id])
  end

  def update
    @league = League.find(params[:id])
    if params[:league][:cover_image_attributes][:file].present?
      @league.cover_image&.destroy
    end

    # @league.build_cover_image
    begin
      @league.update(league_params)
    rescue Exception => e
      @league.update(league_params.except(:cover_image_attributes))
    end

    assign_players_from_excel(params[:league][:players_file])

    redirect_to league_path(@league)
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

  def assign_players_from_excel(data_file)
    return unless data_file
    players = process_excel(data_file)
    @tournament.players = players
  end
end
