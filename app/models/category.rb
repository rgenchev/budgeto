class Category < ApplicationRecord
  belongs_to :household
  has_many :expenses, dependent: :destroy

  validates :name, presence: true
  validates :monthly_budget, numericality: { greater_than: 0 }, allow_nil: true
end
