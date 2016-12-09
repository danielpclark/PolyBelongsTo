class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :work_order_id

      t.timestamps null: false
    end
    add_index :events, :work_order_id
  end
end
