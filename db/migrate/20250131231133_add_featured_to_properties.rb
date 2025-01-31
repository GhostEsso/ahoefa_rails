class AddFeaturedToProperties < ActiveRecord::Migration[7.1]
  def change
    add_column :properties, :featured, :boolean, default: false
  end
end
