class CreateCommunities < ActiveRecord::Migration[8.0]
  def change
    create_table :communities do |t|
      t.string :name
      t.text :description
      t.boolean :public, default: true
      t.timestamps
    end
  end
end
