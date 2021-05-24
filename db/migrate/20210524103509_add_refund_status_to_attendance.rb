class AddRefundStatusToAttendance < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :refund_status, :integer, default: 0
  end
end
