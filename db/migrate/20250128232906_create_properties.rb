class CreateProperties < ActiveRecord::Migration[8.0]
  def change
    create_table :properties do |t|
      t.string :title
      t.text :description
      t.decimal :price
      t.string :address
      t.string :city
      t.string :property_type
      t.integer :bedrooms
      t.integer :bathrooms
      t.decimal :surface
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
