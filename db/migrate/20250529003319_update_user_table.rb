class UpdateUserTable < ActiveRecord::Migration[8.0]
  def change
    remove_column :user_details, :finance_id, if_exists: true
    add_column :users, :finance_id, :integer, null: true
  end
end
