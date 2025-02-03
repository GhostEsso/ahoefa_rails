class AddKycFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :approved, :boolean, default: false
    add_column :users, :kyc_status, :string, default: 'pending'
    add_column :users, :kyc_rejection_reason, :text
    add_column :users, :kyc_submitted_at, :datetime
    add_column :users, :kyc_approved_at, :datetime
  end
end
