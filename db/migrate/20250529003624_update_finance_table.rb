class UpdateFinanceTable < ActiveRecord::Migration[8.0]
  def change
    remove_column :finances, :user_id
  end
end
