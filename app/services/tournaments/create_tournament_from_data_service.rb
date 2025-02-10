class CreateTournamentFromDataService
  attr_accessor :tournament, :players

  def initialize(csv_data:, tournament: nil)
    @csv_data = csv_data

    @tournament = tournament || Tournament.new
  end
end
