class CreateTaxes < ActiveRecord::Migration[8.0]
  def change
    create_table :taxes do |t|
      t.decimal :amount, null: false
      t.date :date, null: false
      t.string :note

      t.timestamps
    end
  end
end
