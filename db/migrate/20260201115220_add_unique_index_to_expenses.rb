class AddUniqueIndexToExpenses < ActiveRecord::Migration[8.0]
  def change
    add_index :expenses, [:amount, :category_id, :date, :note], unique: true, name: "index_expenses_on_unique_entry"
  end
end
