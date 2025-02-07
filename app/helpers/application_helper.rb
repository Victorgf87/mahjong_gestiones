module ApplicationHelper

  ##f
  # <span class="bg-blue-100 text-blue-800 text-xs font-medium me-2 px-2.5 py-0.5 rounded-sm dark:bg-blue-900 dark:text-blue-300">Default</span>
  # <span class="bg-gray-100 text-gray-800 text-xs font-medium me-2 px-2.5 py-0.5 rounded-sm dark:bg-gray-700 dark:text-gray-300">Dark</span>
  # <span class="bg-red-100 text-red-800 text-xs font-medium me-2 px-2.5 py-0.5 rounded-sm dark:bg-red-900 dark:text-red-300">Red</span>
  # <span class="bg-green-100 text-green-800 text-xs font-medium me-2 px-2.5 py-0.5 rounded-sm dark:bg-green-900 dark:text-green-300">Green</span>
  # <span class="bg-yellow-100 text-yellow-800 text-xs font-medium me-2 px-2.5 py-0.5 rounded-sm dark:bg-yellow-900 dark:text-yellow-300">Yellow</span>
  # <span class="bg-indigo-100 text-indigo-800 text-xs font-medium me-2 px-2.5 py-0.5 rounded-sm dark:bg-indigo-900 dark:text-indigo-300">Indigo</span>
  # <span class="bg-purple-100 text-purple-800 text-xs font-medium me-2 px-2.5 py-0.5 rounded-sm dark:bg-purple-900 dark:text-purple-300">Purple</span>
  # <span class="bg-pink-100 text-pink-800 text-xs font-medium me-2 px-2.5 py-0.5 rounded-sm dark:bg-pink-900 dark:text-pink-300">Pink</span>
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
      return pill_button(color, args.first)
    end

    super
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.end_with?("_badge") || super
  end
end
