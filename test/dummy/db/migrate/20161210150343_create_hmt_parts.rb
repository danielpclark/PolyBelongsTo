class CreateHmtParts < ActiveRecord::Migration
  def change
    create_table :hmt_parts do |t|

      t.timestamps null: false
    end
  end
end
