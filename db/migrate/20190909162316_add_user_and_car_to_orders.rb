class AddUserAndCarToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :user_id, :integer
    add_column :orders, :car_id, :integer
  end
end
