class ChangeAvatarToUser < ActiveRecord::Migration[6.0]
  def change
		rename_column :users, :avatar, :image
  end
end
