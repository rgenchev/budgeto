module ApplicationHelper
  BADGE_COLORS = %w[#3b82f6 #10b981 #8b5cf6 #f43f5e #f59e0b #06b6d4 #ec4899 #14b8a6].freeze

  def user_badge_color(user)
    BADGE_COLORS[user.id % BADGE_COLORS.length]
  end

  def user_badge_style(user, size: 28, font_size: 11)
    color = user_badge_color(user)
    "width:#{size}px;height:#{size}px;border-radius:50%;background-color:#{color};display:inline-flex;align-items:center;justify-content:center;font-size:#{font_size}px;font-weight:700;color:white;flex-shrink:0;line-height:1;"
  end


  def number_to_eur(number)
    number_to_currency(number, unit: "€", delimiter: ".", separator: ",")
  end

  def link_primary_classes
    "rounded-md bg-black px-3 py-2 text-white cursor-pointer hover:bg-gray-700"
  end

  def label_classes
    "block text-xs text-gray-500 mb-1"
  end

  def input_classes
    "block w-full rounded-md border-gray-300 shadow-sm px-3 py-2 focus:outline-none focus:border-gray-300 focus:ring-1 focus:ring-gray-300"
  end
end
