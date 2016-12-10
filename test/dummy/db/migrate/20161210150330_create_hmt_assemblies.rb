class CreateHmtAssemblies < ActiveRecord::Migration
  def change
    create_table :hmt_assemblies do |t|

      t.timestamps null: false
    end
  end
end
