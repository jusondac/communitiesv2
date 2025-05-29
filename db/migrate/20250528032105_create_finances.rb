class CreateFinances < ActiveRecord::Migration[8.0]
  def change
    create_table :finances do |t|
      t.integer :balance
      t.references :payment_transaction, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
