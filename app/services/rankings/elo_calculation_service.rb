module Rankings
  class EloCalculationService
    def initialize(elo_inicial = 1500, k_factor = 32)
      @elo_inicial = elo_inicial
      @k_factor = k_factor
      @jugadores = {}
    end

    def call(games)
      resultados_partidas = games.map(&:players_by_scores)
      resultados_partidas.each do |partida|
        elos = partida.map { |jugador| obtener_elo(jugador) }

        partida.each_with_index do |jugador, posicion|
          elo_actual = elos[posicion]
          elos_oponentes = elos.dup
          elos_oponentes.delete_at(posicion)

          expectativa = calcular_expectativa(elo_actual, elos_oponentes)
          puntuacion = (3 - posicion) / 3.0

          nuevo_elo = elo_actual + @k_factor * (puntuacion - expectativa)
          actualizar_elo(jugador, nuevo_elo)
        end
      end


      @jugadores
    end

    private

    def obtener_elo(jugador)
      @jugadores[jugador] ||= { elo: @elo_inicial, partidas: 0 }
      @jugadores[jugador][:elo]
    end

    def actualizar_elo(jugador, nuevo_elo)
      @jugadores[jugador] ||= { elo: @elo_inicial, partidas: 0 }
      @jugadores[jugador][:elo] = nuevo_elo
      @jugadores[jugador][:partidas] += 1
    end

    def calcular_expectativa(elo_jugador, elos_oponentes)
      expectativa = elos_oponentes.sum do |elo_oponente|
        1.0 / (1.0 + 10 ** ((elo_oponente - elo_jugador) / 400.0))
      end
      expectativa / elos_oponentes.length
    end
  end
end
# Ejemplo de uso:
# resultados_partidas = [
#   ["Jugador1", "Jugador2", "Jugador3", "Jugador4"],
#   ["Jugador2", "Jugador4", "Jugador1", "Jugador3"],
#   ["Jugador3", "Jugador1", "Jugador4", "Jugador2"]
# ]
#
# elo_mahjong = EloMahjong.new
# elos_finales = elo_mahjong.calcular_elo(resultados_partidas)
#
# elos_finales.each do |jugador, datos|
#   puts "#{jugador}: ELO #{datos[:elo].round(2)}, Partidas jugadas: #{datos[:partidas]}"
# end
