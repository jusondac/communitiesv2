class CreateUserCommunityRoles < ActiveRecord::Migration[8.0]
  def change
    create_table :user_community_roles do |t|
      t.string :name
      t.references :user_community, null: false, foreign_key: true
      t.integer :position
      t.text :description
      t.integer :parent_id

      t.timestamps
    end
  end
end
