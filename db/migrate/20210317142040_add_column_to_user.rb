class AddColumnToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :status, :integer, limit: 2, default: 0, unsigned: true
  end
end
