class ChangePayTypeToString < ActiveRecord::Migration[5.2]
  def change
    change_column :orders, :pay_type, :string
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
