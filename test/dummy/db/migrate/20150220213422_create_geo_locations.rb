class CreateGeoLocations < ActiveRecord::Migration
  def change
    create_table :geo_locations do |t|
      t.integer :address_id
      t.string :content

      t.timestamps
    end
    add_index :geo_locations, :address_id
  end
end
