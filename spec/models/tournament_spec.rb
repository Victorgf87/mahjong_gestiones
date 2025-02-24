RSpec.describe Tournament, type: :model do
  # let(:tournament){create(:tournament)}
  let(:players_amount) { 16 }
  let(:round_amount) { 2 }
  subject(:tournament) { FactoryBot.create(:tournament, creator: User.first, players: create_list(:player, players_amount), round_amount: round_amount) }
  let(:players) { create_list(:player, 4) }

  it 'is valid' do
    expect(tournament).to be_valid
  end

  let(:pairings_service_json) { '{"playersAmount":"16","roundsAmount":"2","pairings":[{"round":1,"tables":{"0":[14,2,12,7],"1":[16,3,9,5],"2":[1,10,8,15],"3":[6,11,13,4]}},{"round":2,"tables":{"0":[3,7,10,15],"1":[13,5,4,9],"2":[8,11,14,1],"3":[12,6,2,16]}}]}' }
  let(:service_response) { double(code: 200, body: pairings_service_json) }
  let(:supabase_pairings_service) { instance_double(SupabasePairingsService, call: service_response) }

  before do
    allow(SupabasePairingsService).to receive(:new).and_return(supabase_pairings_service)
  end

  it_behaves_like 'eventable' do
    let(:resource) { tournament }
  end

  describe '#generate_pairings' do
    it 'works' do
      total_tables = (players_amount / 4) * round_amount
      expect { tournament.generate_pairings }.to change { Game.count }.by(total_tables)

      expect(tournament.reload.games.count).to eq(total_tables)
      expect(tournament.games.map { _1.players.count }.uniq).to eq([ 4 ])
    end

    it 'games have table and round' do
      tournament.generate_pairings
      expect(tournament.games.where(round: nil).pluck(:round)).to be_blank
      expect(tournament.games.where(table: nil).pluck(:table)).to be_blank
    end

    # curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/pairings' \
    #                                     --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    #   --header 'Content-Type: application/json' \
    #   --data '{"name":"Functions"}'
  end

  # describe 'associations' do
  #
  #   it 'eventable works correctly' do
  #     league.games.create(players: players)
  #     expect(league.games.count).to eq(1)
  #   end
  # end
end
