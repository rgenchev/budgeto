class AddUserToIncomesAndTaxes < ActiveRecord::Migration[8.0]
  def change
    add_reference :incomes, :user, null: true, foreign_key: true
    add_reference :taxes,   :user, null: true, foreign_key: true
  end
end
