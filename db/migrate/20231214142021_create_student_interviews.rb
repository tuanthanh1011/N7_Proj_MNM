class CreateStudentInterviews < ActiveRecord::Migration[7.1]
  def change
    create_table :student_interview, if_not_exists: true do |t|
      t.string :StudentCode
      t.integer :InterviewCode
      t.boolean :ResultInterview
      t.timestamps
    end
  end
end
