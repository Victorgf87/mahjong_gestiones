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
  player2 = Player.create(name: 'Rosa', surname: 'Melano', ema_number: '22222222')
  player3 = Player.create(name: 'Larra', surname: 'Jalano', ema_number: '22222223')
  player4 = Player.create(name: 'Aitor', surname: 'Tilla', ema_number: '22222224')

  FactoryBot.create_list(:player, 84)

  victor = User.create(email_address: 'victor.gf87@gmail.com', password: 'jaja', player: player_victor)

  Tournament.create(name: 'Sekai Taikai', players: Player.all, creator: victor)

  league = League.create(name: 'Liga de Madrid', players: Player.all, creator: victor)


  players = Player.all.take(4)
  game = Game.create(event: league, players: players)


  game.hands.create(winner: player_victor, loser: player2, points: 16)
  game.hands.create(winner: player_victor, loser: player3, points: 16)
  game.hands.create(winner: player_victor, loser: nil, points: 16)
end
