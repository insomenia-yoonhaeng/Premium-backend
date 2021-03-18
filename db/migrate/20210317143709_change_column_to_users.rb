class ChangeColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :user_type, :integer, limit: 2, default: 0, unsigned: true
  end
end
