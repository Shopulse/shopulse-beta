class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :user_info_id
      t.string :name
      t.decimal :price
      t.decimal :sale_price
      t.string :brand
      t.text :description
      t.text :material
      t.string :sizes
      t.text :images
      t.string :gender

      t.timestamps
    end
  end
end
