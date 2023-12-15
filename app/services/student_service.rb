# services/student_service.rb
class StudentService
    def self.findStudentById (studentCode)
        student = Student.find_by(StudentCode: studentCode)
        if student 
          return true
        else
          return false
        end
      end

    def self.isVolunteer (studentCode)
      student = Student.find_by(StudentCode: studentCode, isVolunteerStudent: true)
      if student 
        return true
      else
        return false
      end
    end 

  end