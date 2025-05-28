class CreateUserCommunities < ActiveRecord::Migration[8.0]
  def change
    create_table :user_communities do |t|
      t.references :user, null: false, foreign_key: true
      t.references :community, null: false, foreign_key: true
      t.boolean :approved
      t.integer :user_type, default: 0, null: false # 0 for member, 1 for subscriber

      t.timestamps
    end
  end
end
