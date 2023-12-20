class StudentInterview < ApplicationRecord
    self.table_name = 'student_interview'
    belongs_to :student, foreign_key: 'StudentCode', primary_key: 'StudentCode'
end
