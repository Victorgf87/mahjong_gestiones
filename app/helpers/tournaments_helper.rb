module TournamentsHelper

  def status_badge(tournament)
    color = tournament.status_color

    send("#{color}_badge", tournament.status.capitalize)
    # <%=purple_badge('hola') %>

  end

end
