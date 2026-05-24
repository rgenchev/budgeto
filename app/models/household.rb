class Household < ApplicationRecord
  has_many :users
  has_many :expenses
  has_many :incomes
  has_many :taxes
  has_many :categories
end
