class CreateAuths < ActiveRecord::Migration[6.0]
  def change
    create_table :auths do |t|
      t.string :description
      t.references :authable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
