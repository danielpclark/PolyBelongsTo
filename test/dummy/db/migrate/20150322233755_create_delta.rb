class CreateDelta < ActiveRecord::Migration
  def change
    create_table :delta do |t|
      t.string :content
      t.references :capa, index: true

      t.timestamps
    end
  end
end
