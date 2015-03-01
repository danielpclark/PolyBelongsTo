class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.references :user, index: true
      t.string :content

      t.timestamps
    end
  end
end
