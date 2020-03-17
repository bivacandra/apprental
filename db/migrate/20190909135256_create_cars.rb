class CreateCars < ActiveRecord::Migration[5.2]
  def change
    create_table :cars do |t|
      t.string :name
      t.text :description
      t.string :image
      t.decimal :price, precision: 10, scale: 2
      t.string :status
      t.string :license_plate
      t.string :model
      t.string :manufactor
      t.string :transmission

      t.timestamps
    end
  end
end
