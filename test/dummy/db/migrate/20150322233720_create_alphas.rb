class CreateAlphas < ActiveRecord::Migration
  def change
    create_table :alphas do |t|
      t.string :content
      t.references :delta, index: true

      t.timestamps
    end
  end
end
