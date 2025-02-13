class TournamentsController < ApplicationController
  def index
    @tournaments = Tournament.all
  end

  def new
    @tournament = Tournament.new
    @tournament.build_cover_image
  end

  def edit
    @tournament = Tournament.find(params[:id])
    unless @tournament.cover_image.present?
      @tournament.build_cover_image
    end
  end

  def update
    @tournament = Tournament.find(params[:id])
    if params[:tournament][:cover_image_attributes][:file].present?
      @tournament.cover_image&.destroy
    end

    # @tournament.build_cover_image
    begin
      @tournament.update(create_params)
    rescue Exception => e
      @tournament.update(create_params.except(:cover_image_attributes))
    end

    assign_players_from_excel(params[:tournament][:players_file])

    redirect_to tournament_path(@tournament)
  end

  def show
    @tournament = Tournament.find(params[:id])
  end

  def create
    @tournament = Tournament.new(create_params.merge(creator: Current.user))

    if @tournament.valid?
      assign_players_from_excel(params[:tournament][:players_file])
      @tournament.save
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def assign_players_from_excel(data_file)
    return unless data_file
    players = process_excel(data_file)
    @tournament.players = players
  end

  def destroy
    flash.alert = t("translations.success")
    redirect_to action: :index
  end

  private

  def process_excel(excel_file)
    data = Roo::Spreadsheet.open(excel_file.tempfile)
    data = data.sheet(0)

    data = data.map { _1.map(&:to_s) }

    players = data.map do |ema_number, name, surname|
      player = Player.find_or_initialize_by(ema_number: ema_number)

      player_data = { name:, surname: }

      player.assign_attributes(player_data)
      player.save!
      player
      # if player.persisted?
      #   player.update(player_data)
      # else
      #   player.set_attributes(player_data)
      #
      # end
    end

    players
  end

  def create_params
    puts "Params son #{params.as_json}"
    params.require(:tournament).permit(:name, :start_date, :end_date, :location_name, :location_address, :round_amount, :description, cover_image_attributes: [:image_type, :file])
  end
end
