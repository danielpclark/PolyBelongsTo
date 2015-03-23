class CreateCapas < ActiveRecord::Migration
  def change
    create_table :capas do |t|
      t.string :content
      t.references :beta, index: true

      t.timestamps
    end
  end
end
