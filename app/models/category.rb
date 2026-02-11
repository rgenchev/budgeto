class Category < ApplicationRecord
  has_many :expenses, dependent: :destroy

  validates :name, presence: true
  validates :monthly_budget, numericality: { greater_than: 0 }, allow_nil: true
end
