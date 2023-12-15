class StudentInterviewService
    def self.isApplyInterview (studentCode)
    studentInterview = StudentInterview.find_by(StudentCode: studentCode, ResultInterview: nil)
        if studentInterview
          return true
        else
          return false
        end
    end

  end