module ApplicationHelper
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
