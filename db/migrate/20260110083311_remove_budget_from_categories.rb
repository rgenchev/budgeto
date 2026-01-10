class RemoveBudgetFromCategories < ActiveRecord::Migration[8.0]
  def change
    remove_column :categories, :budget
  end
end
