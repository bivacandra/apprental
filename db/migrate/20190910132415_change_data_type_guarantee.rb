class ChangeDataTypeGuarantee < ActiveRecord::Migration[5.2]
  def change
    change_column :orders, :guarantee, 'integer USING CAST(guarantee AS integer)'
  end
end
