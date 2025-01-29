class AddBlockedUntilToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :blocked_until, :datetime
    add_index :users, :blocked_until
  end
end
