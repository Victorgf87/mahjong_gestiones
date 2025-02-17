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
    @league.build_cover_image unless @league.cover_image.present?
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

  def create_game
    @league = League.find(params[:id])
    if params.fetch(:league, nil)&.fetch(:players_file, nil).present?
      file_content =  process_game_excel(params[:league][:players_file])
      new_game = Games::CreateFromFileService.new(file_content:, event: @league).call

      new_game.fill_scoring
    end


    redirect_to @league, notice: t("translations.created_correctly", what: t("translations.league")).capitalize
  end

  private

  def process_game_excel(excel_file)
    data = Roo::Spreadsheet.open(excel_file.tempfile)
    data = data.sheet(0)

    data = data.map { _1.map(&:to_i) }
  end

  def process_excel(excel_file)
    data = Roo::Spreadsheet.open(excel_file.tempfile)
    data = data.sheet(0)

    data = data.map { _1.map(&:to_i).map(&:to_i) }

    players = data.map do |ema_number, name, surname|
      player = Player.find_or_initialize_by(ema_number: ema_number)

      player_data = { name:, surname: }

      player.assign_attributes(player_data)
      player.save!
      player
    end

    players
  end

  def league_params
    params.require(:league).permit(:name, :description, :start_date, :end_date, cover_image_attributes: [ :image_type, :file ])
  end

  def assign_players_from_excel(data_file)
    return unless data_file
    players = process_excel(data_file)
    @league.players = players
  end
end
