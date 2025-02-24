FactoryBot.define do
  factory :player do
    name { Faker::Name.name }
    surname { Faker::Name.last_name }
    ema_number { Faker::Number.number(digits: 8) }
  end
end
