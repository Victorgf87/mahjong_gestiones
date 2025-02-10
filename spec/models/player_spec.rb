
describe Player, type: :model do
  subject(:player) { create(:player) }
  it 'user is not required' do
    player.user = nil
    player.save!
    expect(player.reload.user).to be_nil
  end
end
