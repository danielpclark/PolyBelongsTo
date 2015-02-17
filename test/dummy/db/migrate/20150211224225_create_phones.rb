class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.references :phoneable, polymorphic: true, index: true
      t.string :content

      t.timestamps null: false
    end
  end
end
