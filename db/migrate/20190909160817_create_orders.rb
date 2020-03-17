class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|

      t.string :name
      t.string :tel
      t.text :address
      t.string :email
      t.string :pay_type
      t.string :status

      t.timestamp :checkout_time
      t.timestamp :return_time
      t.timestamp :real_checkout_time
      t.timestamp :real_return_time

      t.decimal :charge, precision: 10, scale: 2

      t.timestamps
    end
  end
end
