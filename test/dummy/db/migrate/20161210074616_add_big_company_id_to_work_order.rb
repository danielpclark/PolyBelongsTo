class AddBigCompanyIdToWorkOrder < ActiveRecord::Migration
  def change
    add_column :work_orders, :big_company_id, :integer
    add_index :work_orders, :big_company_id
  end
end
