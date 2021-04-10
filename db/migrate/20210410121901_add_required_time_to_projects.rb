class AddRequiredTimeToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :required_time, :integer, default: 0
  end
end
