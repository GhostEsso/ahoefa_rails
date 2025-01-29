class DropPhotosTable < ActiveRecord::Migration[8.0]
  def up
    drop_table :photos if table_exists?(:photos)
  end

  def down
    create_table :photos do |t|
      t.string :url
      t.references :property, null: false, foreign_key: true

      t.timestamps
    end
  end
end
