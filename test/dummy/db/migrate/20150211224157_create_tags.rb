class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :user_id

      t.timestamps null: false
    end
    add_index :tags, :user_id
  end
end
