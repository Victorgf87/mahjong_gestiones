require "tty-prompt"

namespace :create_game do
  desc "Create a new game"
  task new: :environment do
    puts League.count
    CreateGame.new.start
  end

  class CreateGame
    attr_accessor :event_type
    attr_accessor :prompt

    def initialize
      @prompt = TTY::Prompt.new
    end

    def start
      create_for_league
      # opcion = prompt.select("Para qué vas a crear este juego?") do |menu|
      #   menu.choice 'Torneo', "tournament"
      #   menu.choice 'Liga', 'league'
      #   menu.choice 'Salir', nil
      # end
      #
      # return if opcion.nil?
      #
      # case opcion
      # when 'tournament'
      #   create_for_tournament
      # when 'league'
      #   create_for_league
      # end
    end

    def create_for_tournament
      raise "Not implemented"
      # TODO Impelement
    end

    def select_players
      player = nil
      # 90 89 91
      while player == nil
        player_number = prompt.ask("player_number del jugador")
        player = Player.find_by(player_number: player_number)
        confirmation = prompt.yes?("Estás seguro de que quieres agregar a #{player.full_name} ema #{player.ema_number}?")
        player = nil unless confirmation
      end
      player
    end

    def generate_hands(game)
      continue = true
      puts "Generando manos"
      players = game.players
      inserted_amount = 0

      while continue
        puts "Mano #{inserted_amount + 1}"
        points = prompt.ask("Cuántos puntos?")

        winner_id = prompt.select("Quién ganó la mano?") do |menu|
          players.each do |p|
            menu.choice p.full_name, p.id
          end
          menu.choice "Nadie", nil
        end

        if winner_id.nil?
          loser_id = nil
        else
          loser_id = prompt.select("Quién dio la ficha?") do |menu|
            menu.choice "Nadie", nil
            players.each do |p|
              menu.choice p.full_name, p.id
            end
          end
        end



        game.hands.new(winner_id:, loser_id:, points:)

        # opcion = prompt.select("Para qué vas a crear este juego?") do |menu|
        #   menu.choice 'Torneo', "tournament"
        #   menu.choice 'Liga', 'league'
        #   menu.choice 'Salir', nil
        # end
        continue = prompt.yes?("Quieres agregar otra mano?")
        inserted_amount += 1
      end
    end

    def create_for_league
      leagues = League.all

      options = leagues.pluck(:id, :name)
      selected_id = prompt.select("Elige cual") do |menu|
        options.each do |option|
          menu.choice option[1], option[0]
        end
      end

      league = League.find(selected_id)
      puts "Creando partida para #{league.name}"

      players = 4.times.map { select_players }

      game = Game.new(event: league, players: players)
      generate_hands(game)
      game.save!
    end
  end
end
