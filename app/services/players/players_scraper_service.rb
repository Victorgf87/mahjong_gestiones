require 'nokogiri'
require 'open-uri'

module Players
  class PlayersScraperService
    URL = 'http://mahjong-europe.org/ranking/mcr.html'

    def self.scrape_players
      doc = Nokogiri::HTML(URI.open(URL))
      table = doc.css('table.ranking-list')
      players = []

      table.css('tr').each_with_index do |row, index|
        next if index == 0 # Saltamos la fila de encabezados

        player = {
          new_rank: row.css('td')[0].text.strip,
          old_rank: row.css('td')[1].text.strip,
          id: row.css('td')[3].text.strip,
          last_name: row.css('td')[4].text.strip,
          first_name: row.css('td')[5].text.strip,
          country: row.css('td')[6].text.strip,
          total_points: row.css('td')[7].text.strip,
          tournaments: row.css('td')[8].text.strip,
          contributes_to_mers: row.css('td')[9].text.strip,
          plays_riichi: row.css('td')[10].text.strip
        }

        players << player
      end

      players
    end
  end
end

# Uso del scraper
# players = PlayerScraper.scrape_players
# puts "Se han obtenido #{players.count} jugadores."
