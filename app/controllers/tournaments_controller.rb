class TournamentsController < ApplicationController
  def index
    @tournaments = Tournament.all
  end
  def new
    @tournament = Tournament.new
  end

  def show
    @tournament = Tournament.find(params[:id])
  end

  def create
    players = process_excel(params[:tournament][:players_file])
    @tournament = Tournament.new(create_params.merge(creator: Current.user))
    @tournament.players = players
    if @tournament.save
      redirect_to action: :index
    else
      render action: :new
    end
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
      player.save
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
    params.require(:tournament).permit(:name)
  end
end
