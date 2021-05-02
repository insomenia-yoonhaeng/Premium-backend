class AddColumnToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :status, :integer, default: 0
  end
end
