class CreateSsns < ActiveRecord::Migration
  def change
    create_table :ssns do |t|
      t.integer :user_id
      t.string :content

      t.timestamps
    end
    add_index :ssns, :user_id
  end
end
