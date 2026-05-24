class AddHouseholdToAll < ActiveRecord::Migration[8.0]
  def up
    add_reference :users,      :household, null: true, foreign_key: true
    add_reference :expenses,   :household, null: true, foreign_key: true
    add_reference :incomes,    :household, null: true, foreign_key: true
    add_reference :taxes,      :household, null: true, foreign_key: true
    add_reference :categories, :household, null: true, foreign_key: true

    household = Household.create!(name: "Home")
    User.update_all(household_id: household.id)
    Expense.update_all(household_id: household.id)
    Income.update_all(household_id: household.id)
    Tax.update_all(household_id: household.id)
    Category.update_all(household_id: household.id)

    change_column_null :users,      :household_id, false
    change_column_null :expenses,   :household_id, false
    change_column_null :incomes,    :household_id, false
    change_column_null :taxes,      :household_id, false
    change_column_null :categories, :household_id, false
  end

  def down
    remove_reference :users,      :household, foreign_key: true
    remove_reference :expenses,   :household, foreign_key: true
    remove_reference :incomes,    :household, foreign_key: true
    remove_reference :taxes,      :household, foreign_key: true
    remove_reference :categories, :household, foreign_key: true
  end
end
