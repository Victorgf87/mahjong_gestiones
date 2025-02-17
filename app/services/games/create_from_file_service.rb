module Games
  class CreateFromFileService
    attr_reader :file_content, :event

    def initialize(file_content:, event: nil)
      @file_content = file_content
      @event = event
    end

    def call
      # processed_game = process_game_excel(params[:league][:players_file])

      player_numbers, *hands = file_content

      players = Player.where(player_number: player_numbers)

      new_game = event.present? ? event.games.new(players:) : Game.new(players:)

      index = 0

      final_hands_data = hands.map do |score, winner_param, loser_param|
        if score.zero?
          winner = nil
          loser = nil
        else
          # winner = players.find { _1.player_number == winner_param }
          # loser = players.find { _1.player_number == loser_param }
          winner = players.find_by(player_number: winner_param)
          loser = players.find_by(player_number: loser_param)

          raise "Nope #{winner.nil?} | #{loser.nil?} " if winner.nil?
        end

        index += 1
        hand = new_game.hands.new(winner: winner, loser: loser, points: score, position: index)
      end

      seat_names = %w[east south west north]

      new_game.save!
      player_numbers.map do |player_number|
        players.where(player_number:)
      end.each_with_index do |player, index|
        new_game.game_players.where(player:).update(seat: seat_names[index])
      end
      new_game.reload.game_players
      new_game
    end
  end
end
