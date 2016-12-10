class CreateAssemblies < ActiveRecord::Migration
  def change
    create_table :assemblies do |t|

      t.timestamps null: false
    end
  end
end
