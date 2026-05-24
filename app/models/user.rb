class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :expenses, dependent: :nullify
  has_many :incomes, dependent: :nullify
  has_many :taxes, dependent: :nullify
  belongs_to :household

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  normalizes :first_name, :last_name, with: ->(v) { v.strip }

  def initials
    if first_name.present? || last_name.present?
      [first_name.presence&.first, last_name.presence&.first].compact.join.upcase
    else
      email_address.first.upcase
    end
  end

  def display_name
    full = [first_name, last_name].compact.join(" ")
    full.present? ? full : email_address
  end
end
