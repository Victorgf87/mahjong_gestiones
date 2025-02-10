FactoryBot.define do
  factory :tournament do
    name { Faker::Name.unique.name }
  end
end
