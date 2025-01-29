class AddAnnualToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :annual, :boolean, default: false
  end
end
