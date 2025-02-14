
describe Player, type: :model do
  subject(:player) { create(:player) }
  it 'user is not required' do
    player.user = nil
    player.save!
    expect(player.reload.user).to be_nil
  end

  it 'player_number works correctly' do
    player1 = create(:player)
    expect(player1.reload.player_number).not_to eq(0)
    expect(player1.reload.player_number).not_to eq(nil)
    number = player1.reload.player_number
    player1.save
    expect(player1.reload.player_number).to eq(number)
  end
end
