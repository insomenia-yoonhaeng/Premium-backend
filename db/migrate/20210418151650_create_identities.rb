class CreateIdentities < ActiveRecord::Migration[6.0]
  def change
    create_table :identities do |t|
      t.references :user, null: true, foreign_key: true
      t.string :provider
      t.string :uid

      t.timestamps
    end
    remove_column :users, :password_digest
    add_column :users, :account_type, :string
  end
end
