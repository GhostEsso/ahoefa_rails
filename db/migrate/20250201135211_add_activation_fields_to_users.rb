class AddActivationFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :activation_code, :string
    add_column :users, :activation_code_sent_at, :datetime
    add_column :users, :activated_at, :datetime
    add_index :users, :activation_code, unique: true
  end
end
