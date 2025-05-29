class UpdateTableChanges < ActiveRecord::Migration[8.0]
  def change
    remove_column :finances, :payment_transaction_id, if_exists: true

    add_column :finances, :is_community, :boolean, default: false
    add_column :user_details, :finance_id, :integer
    add_column :communities, :finance_id, :integer
  end
end
