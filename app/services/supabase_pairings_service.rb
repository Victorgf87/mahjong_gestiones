class SupabasePairingsService
  # response = HTTParty.get(
  #   'http://127.0.0.1:54321/functions/v1/pairings',
  #   query: { players: 16, rounds: 2 },
  #   headers: {
  #     'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0',
  #     'Content-Type' => 'application/json'
  #   }
  # )

  attr_accessor :players, :rounds

  def initialize(players, rounds)
    @players = players
    @rounds = rounds
  end


  def call
    #TODO: Cover error cases
    call_result = HTTParty.get(
      ENV["SUPABASE_PAIRINGS_URL"],
      query: { players: players, rounds: rounds },
      headers: {
        "Authorization" => "Bearer #{Rails.application.credentials.supabase_secret}",
        "Content-Type" => "application/json"
      }
    )
    call_result
  end
end
