class CreateBeta < ActiveRecord::Migration
  def change
    create_table :beta do |t|
      t.string :content
      t.references :alpha, index: true

      t.timestamps
    end
  end
end
