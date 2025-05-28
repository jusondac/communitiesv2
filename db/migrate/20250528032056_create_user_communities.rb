class CreateUserCommunities < ActiveRecord::Migration[8.0]
  def change
    create_table :user_communities do |t|
      t.references :user, null: false, foreign_key: true
      t.references :community, null: false, foreign_key: true
      t.boolean :approved
      t.integer :type

      t.timestamps
    end
  end
end
