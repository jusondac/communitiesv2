class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.integer :payer_id
      t.integer :receiver_id
      t.integer :category
      t.integer :status
      t.integer :amount
      t.references :payment_method, null: false, foreign_key: true

      t.timestamps
    end
  end
end
