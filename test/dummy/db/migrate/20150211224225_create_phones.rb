class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.references :phoneable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
