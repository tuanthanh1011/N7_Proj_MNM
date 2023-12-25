class StudentActivity < ApplicationRecord
    self.table_name = 'student_activity'
    belongs_to :student, foreign_key: 'StudentCode', primary_key: 'StudentCode'
    belongs_to :activity, foreign_key: 'ActivityCode', primary_key: 'ActivityCode'
end
