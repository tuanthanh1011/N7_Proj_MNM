class CreateInterviews < ActiveRecord::Migration[7.1]
  def change
    create_table :interview, if_not_exists: true do |t|
      t.integer :InterviewCode
      t.date :InterviewDate
      t.string :InterviewRoom
      t.integer :Quantity
      t.integer :QuantityMax

      t.timestamps
    end
  end
end
