class CreateBigCompanies < ActiveRecord::Migration
  def change
    create_table :big_companies do |t|

      t.timestamps null: false
    end
  end
end
