class CreateAuths < ActiveRecord::Migration[7.1]
  def change
    create_table :auths do |t|
      t.integer :AccountCode
      t.string :UserName
      t.string :Password
      t.boolean :Role

      t.timestamps
    end
  end
end
