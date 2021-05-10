class AddHolidayToOption < ActiveRecord::Migration[6.0]
  def change
    add_column :options, :holiday, :integer, default: 0
  end
end
