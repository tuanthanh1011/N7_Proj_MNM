class CreateStudentActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :student_activities do |t|
      t.integer :ActivityCode
      t.string :StudentCode
      t.integer :RatingCode

      t.timestamps
    end
  end
end
