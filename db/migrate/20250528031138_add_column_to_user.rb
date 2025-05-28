class AddColumnToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :username, :string, null: false, default: SecureRandom.hex(5)[0, 9]
  end
end
