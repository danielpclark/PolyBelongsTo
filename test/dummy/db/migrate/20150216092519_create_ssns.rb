class CreateSsns < ActiveRecord::Migration
  def change
    create_table :ssns do |t|
      t.integer :user_id

      t.timestamps
    end
    add_index :ssns, :user_id
  end
end
