RSpec.describe Tournament, type: :model do
  # let(:tournament){create(:tournament)}
  subject(:tournament){FactoryBot.create(:tournament, creator: User.first, players: create_list(:player, 88))}

  it 'is valid' do
    expect(tournament).to be_valid
  end

  describe '#generate_pairings' do
    it 'works' do
      tournament.generate_pairings
    end

    # curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/pairings' \
    #                                     --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    #   --header 'Content-Type: application/json' \
    #   --data '{"name":"Functions"}'
  end
end
