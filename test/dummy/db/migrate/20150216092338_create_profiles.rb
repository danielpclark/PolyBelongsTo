class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :profileable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
