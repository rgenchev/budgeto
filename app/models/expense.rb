# app/models/expense.rb
class Expense < ApplicationRecord
  belongs_to :category

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :date, presence: true
  validates :amount, uniqueness: { scope: [:category_id, :date, :note], message: "duplicate expense already exists" }
end
