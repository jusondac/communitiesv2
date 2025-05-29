class UpdateTableWoRemove < ActiveRecord::Migration[8.0]
  def change
    add_column :finances, :name, :string, null: false, default: ""
  end
end
