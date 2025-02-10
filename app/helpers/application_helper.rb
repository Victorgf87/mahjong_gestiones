module ApplicationHelper
  def google_map(latitude, longitude, zoom = 15)
    content_tag :div, class: "aspect-w-16 aspect-h-9" do
      content_tag :iframe, nil,
                  src: "https://www.google.com/maps/embed/v1/view?key=#{Rails.application.credentials.maps_api_key}&center=#{latitude},#{longitude}&zoom=#{zoom}",
                  class: "w-full h-full rounded-lg",
                  style: "border:0;",
                  allowfullscreen: true,
                  loading: "lazy"
    end
  end

  def badge(color, content)
    "<span class=\"bg-#{color}-100 text-#{color}-800 text-xs font-medium me-2 px-2.5 py-0.5 rounded-sm dark:bg-pink-900 dark:text-#{color}-300\">#{content}</span>".html_safe
  end

  def pill_button(color, content)
    "<button class=\"bg-#{color}-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-full\">
      #{content}
    </button>".html_safe
  end

  def method_missing(method_name, *args)
    method_name = method_name.to_s
    if method_name.end_with?("_badge")
      color = method_name.split("_").first
      return badge(color, args.first)
    end

    if method_name.end_with?("_pill_button")
      color = method_name.gsub("_pill_button", "")
      pill_button(color, args.first)
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.end_with?("_badge") || super
  end
end
