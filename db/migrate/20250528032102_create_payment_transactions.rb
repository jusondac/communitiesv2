class CreatePaymentTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :payment_transactions do |t|
      t.references :user, null: true, foreign_key: true
      t.references :community, null: true, foreign_key: true
      t.boolean :is_community

      t.timestamps
    end
  end
end
