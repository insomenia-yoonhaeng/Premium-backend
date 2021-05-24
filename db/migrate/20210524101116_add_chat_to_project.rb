class AddChatToProject < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :chat, :integer, default: 0
  end
end