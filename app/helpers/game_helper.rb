module GameHelper

  def player_info_in_card(kanji_color, kanji, position, player_score_data)
    player_score_data = OpenStruct.new(player_score_data)

    dynamic_center = if position == 1 || position == 3
                       "self-center"
                     end

    ret =
      <<-HTML
    <div class="col-start-#{position} text-center #{dynamic_center}">
        <p class="text-2xl font-bold text-#{kanji_color}-600">#{kanji} ##{player_score_data.position}</p>
        <p class="text-xs text-gray-500">#{player_score_data.name}</p>
        
        <p class="text-gray-600"> #{player_score_data.score}</p>
      </div>
    HTML

    ret.html_safe
  end
end
