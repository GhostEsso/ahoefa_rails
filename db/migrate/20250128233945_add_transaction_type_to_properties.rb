class AddTransactionTypeToProperties < ActiveRecord::Migration[8.0]
  def change
    add_column :properties, :transaction_type, :string
  end
end
