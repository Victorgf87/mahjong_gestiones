shared_context 'eventable' do
  describe 'associations' do
    let(:players) { create_list(:player, 4) }

    it 'eventable works correctly' do
      resource.games.create(players: players)
      expect(resource.games.count).to eq(1)
    end

    # it 'has many games' do
    #   expect(league.games.count).to eq(0)
    # end
    #
    # it 'has many event_players' do
    #   expect(league.event_players.count).to eq(0)
    # end
    #
    # it 'has many players' do
    #   expect(league.players.count).to eq(0)
    # end
    #
    # it 'belongs to a creator' do
    #   expect(league.creator).to eq(creator)
    # end
  end
end
