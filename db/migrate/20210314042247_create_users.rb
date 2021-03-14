class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email, index: { unique: true }
      t.string :password_digest
      t.integer :user_type
      t.string :phone, index: { unique: true }
      t.string :name
      t.text :info
      t.timestamps
    end
  end
end
