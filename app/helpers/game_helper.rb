module GameHelper

  def player_info_in_card(kanji_color, kanji, position, player)

    dynamic_center = if position == 1 || position == 3
                       "self-center"
                     end

    ret =
      <<-HTML
    <div class="col-start-#{position} text-center #{dynamic_center}">
        <p class="text-2xl font-bold text-#{kanji_color}-600">#{kanji}</p>
        <p class="text-xs text-gray-500">#{player.full_name}</p>
        <!--        <p><%#= game.players.find_by(position: 'north').name %></p>-->
        <!--        <p class="text-gray-600"><%#= game.players.find_by(position: 'north').score %> puntos</p>-->
      </div>
    HTML

    ret.html_safe
  end
end
