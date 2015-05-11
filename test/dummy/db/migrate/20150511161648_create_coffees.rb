class CreateCoffees < ActiveRecord::Migration
  def change
    create_table :coffees do |t|
      t.references :coffeeable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
