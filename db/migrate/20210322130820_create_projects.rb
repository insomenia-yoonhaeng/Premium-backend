class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.references :tutor, references: :users, foreign_key: { to_table: :users }
      t.datetime :experience_period
      t.string :description
      t.integer :deposit
      t.string :image

      t.timestamps
    end
  end
end
