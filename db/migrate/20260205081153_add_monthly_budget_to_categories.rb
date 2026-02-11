class AddMonthlyBudgetToCategories < ActiveRecord::Migration[8.0]
  def change
    add_column :categories, :monthly_budget, :decimal, precision: 10, scale: 2
  end
end
