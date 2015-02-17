class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.references :photoable, polymorphic: true, index: true
      t.string :content

      t.timestamps
    end
  end
end
