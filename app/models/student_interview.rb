class StudentInterview < ApplicationRecord
    self.table_name = 'student_interview'
    belongs_to :student, foreign_key: 'StudentCode', primary_key: 'StudentCode', optional: true
  
    validate do |student_interview|
      student_interview.errors.add(:base, "Trường mã sinh viên không được để trống!") if student_interview.StudentCode.blank?
      student_interview.errors.add(:base, "Trường mã phỏng vấn không được để trống!") if student_interview.InterviewCode.blank?
    end
  end
  