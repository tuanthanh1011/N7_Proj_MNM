class CreateActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :activities do |t|
      t.integer :ActivityCode
      t.string :ActivityName
      t.date :BeginingDate
      t.string :Manager
      t.float :SupportMoney
      t.text :Description
      t.date :CreatedAt
      t.date :UpdatedAt

      t.timestamps
    end
  end
end
