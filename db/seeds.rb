# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

unless Rails.env.production?
  [ Image, Game, Tournament, League, Player, User,  Hand ].each(&:destroy_all)

  player_victor = Player.create(name: 'Victor', surname: 'Gonzalez', ema_number: '10990053')

  players_data = [ { ema_number: '10990082',	surname: 'LU', ame: 'YEYIN' },
                  { ema_number: '10990043',	surname: 'RÍOS',  name: 'RAÚL' },
                  { ema_number: '10990007',	surname: 'MORENO',  name: 'JOSÉ' },
                  { ema_number: '10990027',	surname: 'AYLLÓN',  name: 'ANTONIO' },
                  { ema_number: '10990088',	surname: 'STEPANOVA',  name: 'ANNA' },
                  { ema_number: '10990018',	surname: 'ESCASO',  name: 'HÉCTOR' },
                  { ema_number: '10990057',	surname: 'RUBIO',  name: 'LUIS' },
                  { ema_number: '10990022',	surname: 'VALBUENA',  name: 'CARMEN' },
                  { ema_number: '10990047',	surname: 'PASCUAL',  name: 'MIGUEL' },
                  { ema_number: '10990039',	surname: 'VEGA',  name: 'LA' },
                  { ema_number: '10990070',	surname: 'SOLER',  name: 'DAVID' },
                  { ema_number: '10990099',	surname: 'TOLOCHNYI',  name: 'nikolai' },
                  { ema_number: '10990025',	surname: 'CASTELLANO',  name: 'MARIA' },
                  { ema_number: '10990030',	surname: 'BERNAL',  name: 'JOHANN' },
                  { ema_number: '10990023',	surname: 'TURPÍN',  name: 'ALBERTO' },
                  { ema_number: '10990017',	surname: 'TÚNEZ',  name: 'SAMUEL' },
                  { ema_number: '10990037',	surname: 'TÚNEZ',  name: 'KATIA' },
                  { ema_number: '10990101',	surname: 'ROCA',  name: 'GABRIEL' },
                  { ema_number: '10990097',	surname: 'NAVARRO',  name: 'JESÚS' },
                  { ema_number: '10990100',	surname: 'FERNÁNDEZ',  name: 'RAQUEL' },
                  { ema_number: '10990024',	surname: 'TÚNEZ',  name: 'MARIA' },
                  { ema_number: '10990063',	surname: 'RIQUELME',  name: 'ABRAHAM' },
                  { ema_number: '10990051',	surname: 'SAN',  name: 'SERRANO' },
                  { ema_number: '10990012',	surname: 'FUENTES',  name: 'DIANA' },
                  { ema_number: '10990098',	surname: 'REDONDO',  name: 'MANUELA' } ]

  Player.create!(players_data)

  # FactoryBot.create_list(:player, 84)

  victor = User.create(email_address: 'victor.gf87@gmail.com', password: 'jaja', player: player_victor)

  Tournament.create(name: 'Sekai Taikai', players: Player.all, creator: victor)

  league = League.create(name: 'Liga de Mahjong Madrid', players: Player.all, creator: victor)


  players = Player.all.take(4)
  game = Game.create(event: league, players: players)

  game.hands.create(winner: player_victor, loser: player2, points: 16)
  game.hands.create(winner: player_victor, loser: player3, points: 16)
  game.hands.create(winner: player_victor, loser: nil, points: 16)
end
