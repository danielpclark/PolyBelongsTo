class CreateSquishies < ActiveRecord::Migration
  def change
    create_table :squishies do |t|
      t.string :content
      t.references :squishable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
