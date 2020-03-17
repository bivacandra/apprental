class ChangeDataTypePayType < ActiveRecord::Migration[5.2]
  def change
    change_column :orders, :pay_type, 'integer USING CAST(pay_type AS integer)'
  end
end
