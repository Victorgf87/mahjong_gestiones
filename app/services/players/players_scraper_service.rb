# app/services/player_scraper.rb
require 'open-uri'
require 'nokogiri'

module Players
  class PlayersScraperService
    def initialize(url = 'http://mahjong-europe.org/ranking/mcr.html')
      @url = url
    end

    def scrape
      # Obtener el HTML de la página
      html = URI.open(@url)

      # Parsear el HTML con Nokogiri
      doc = Nokogiri::HTML(html)

      # Aquí obtendrás los datos de los jugadores. Necesitarás inspeccionar el HTML de la página
      # para identificar cómo están organizados los datos.

      # Suponiendo que los jugadores están en una tabla, puedes hacer algo como esto:
      players = []

      # Recorremos las filas de la tabla (modificar el selector según la estructura de la página)
      doc.css('table tr').each do |row|
        # Extraemos las celdas de cada fila
        columns = row.css('td')

        next if columns.empty? # Omitir filas vacías

        # Supongamos que los jugadores tienen un nombre y una puntuación en cada fila
        player_name = columns[0].text.strip
        player_score = columns[1].text.strip

        # Almacenar los datos extraídos
        players << { name: player_name, score: player_score }
      end

      players
    end
  end
end