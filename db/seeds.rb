# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
[ Player, Game, Tournament, User ].each(&:destroy_all)

Player.create(name: 'Victor', surname: 'Gonzalez', ema_number: '10990053')
Player.create(name: 'Rosa', surname: 'Melano', ema_number: '22222222')
Player.create(name: 'Larra', surname: 'Jalano', ema_number: '22222223')
Player.create(name: 'Aitor', surname: 'Tilla', ema_number: '22222224')

victor = User.create(email_address: 'victor.gf87@gmail.com', password: 'jaja')

Tournament.create(name: 'Sekai Taikai', players: Player.all, creator: victor)
