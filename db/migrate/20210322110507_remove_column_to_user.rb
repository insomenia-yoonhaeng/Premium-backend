class RemoveColumnToUser < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :user_type
  end
end
