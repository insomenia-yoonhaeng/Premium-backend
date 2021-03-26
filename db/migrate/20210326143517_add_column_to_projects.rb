class AddColumnToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :name, :string, null: false
    change_column_null :projects, :tutor_id, false
    change_column_null :users, :email, false
    change_column_null :users, :name, false
  end
end
