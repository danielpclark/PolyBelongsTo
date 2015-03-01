class CreateTires < ActiveRecord::Migration
  def change
    create_table :tires do |t|
      t.references :user, index: true
      t.references :car, index: true
      t.string :content

      t.timestamps
    end
  end
end
