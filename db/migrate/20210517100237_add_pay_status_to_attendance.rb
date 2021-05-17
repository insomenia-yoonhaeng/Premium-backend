class AddPayStatusToAttendance < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :pay_status, :integer, default: 0
  end
end
