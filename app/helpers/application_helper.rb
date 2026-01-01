module ApplicationHelper
  def number_to_eur(number)
    number_to_currency(number, unit: "€", delimiter: ".", separator: ",")
  end
end
