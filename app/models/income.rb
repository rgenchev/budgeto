class Income < ApplicationRecord
  belongs_to :household
  belongs_to :user, optional: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :date, presence: true
end
