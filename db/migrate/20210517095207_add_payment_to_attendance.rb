class AddPaymentToAttendance < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :imp_uid, :string
    add_column :attendances, :merchant_uid, :string
    add_column :attendances, :amount, :integer, default: 0
  end
end
