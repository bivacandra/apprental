class AddGuaranteeToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :guarantee, :string
  end
end
