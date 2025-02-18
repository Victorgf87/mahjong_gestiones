FactoryBot.define do
  factory :game_player do
    ##<GamePlayer:0x00007d31feee09c8
    #  id: "073f616a-a6e5-4c18-95d6-d6957f72d41a",
    #  player_id: "9716462c-804b-4847-832d-7a253cdd2ed2",
    #  game_id: "427c1c37-e84c-46f7-9fe4-85cf092b4acb",
    #  created_at: "2025-02-18 11:21:12.209301000 +0000",
    #  updated_at: "2025-02-18 11:21:12.563814000 +0000",
    #  score: 85,
    #  position: 2,
    #  position_weight: 2.0,
    #  seat: "east">
  end

  factory :game_player_for_game do
    trait :normal do

    end
  end
end
