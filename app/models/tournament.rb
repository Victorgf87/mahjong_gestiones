class Tournament < ApplicationRecord
  include Imageable
  include Updatable
  include Gameable

  has_many :players
  validates :name, presence: true

  geocoded_by :location_address
  after_validation :geocode

  belongs_to :creator, class_name: "User", foreign_key: "creator_id"

  enum :status, { draft: 0, ready: 1, progress: 2, finished: 3 }
  has_many :rounds

  validates :status, presence: true

  has_many :event_players, as: :eventable, dependent: :destroy
  has_many :players, through: :event_players

  STATUS_COLORS = {
    'draft': "yellow",
    'ready': "green",
    'progress': "blue",
    'finished': "red"
  }.freeze

  def status_color
    STATUS_COLORS[status.to_sym]
  end

  def generate_pairings
    result = SupabasePairingsService.new(players.count, round_amount).call
    code = result.code
    body = OpenStruct.new(JSON.parse(result.body))
    pairings = body.pairings

    games.destroy_all

    rounds_data = pairings.map do |row|
      [row["round"], row["tables"]]
    end

    final_games_attributes = rounds_data.flat_map do |round_number, round_data|
      mapped_data = round_data.map do |table_number, pairing_numbers|
        players_in_table = pairing_numbers.map do |number|
          players[number - 1].id
        rescue Exception => e
          a = 3
        end
        [table_number, players_in_table]
      end

      mapped_data.map do |table_number, players|
        { player_ids:, round: round_number, table: table_number, event_id: id }
      end
    end

    puts "Generating #{final_games_attributes.count}"

    Game.create(final_games_attributes)
  end

  def ready?
  end
end
