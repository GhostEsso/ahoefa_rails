class AddPlanToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :plan, :string, default: 'basic'
  end
end
