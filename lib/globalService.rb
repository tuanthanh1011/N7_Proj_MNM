module GlobalService
    # Hàm kiểm tra sinh viên có tồn tại không
    def self.isExistsStudent(studentCode)
        student = Student.find_by(StudentCode: studentCode)
        if student
            return { success: true }
        end
        return { success: false, message: "Không tồn tại sinh viên", status: 404}
    end

    # Hàm kiểm tra hoạt động có tồn tại không
    def self.isExistsActivity(activityCode)
        activity = Activity.find_by(ActivityCode: activityCode)
        if activity 
            return { success: true }
        end
        return { success: false, message: "Không tồn tại hoạt động", status: 404}
    end

    # Hàm kiểm tra mảng mã sinh viên đầu vào có vấn đề gì không. 1 id có lỗi ngăn sự kiện thêm
    def self.validate_input(arr_student_code, activity_code)
        error_results = []
        validate_result = true
      
        arr_student_code.each do |student_code|
            student = Student.find_by(StudentCode: student_code)
        
            # Kiểm tra mã sinh viên có tồn tại trên hệ thống?
            unless student
                error_results <<  "Không tồn tại mã sinh viên #{student_code}" 
                validate_result = false
                next
            end
        
            # Kiểm tra sinh viên đã là sinh viên tình nguyện chưa
            unless StudentService.isVolunteer(student_code)
                error_results <<  "Sinh viên mã sinh viên #{student_code} không phải là sinh viên tình nguyện" 
                validate_result = false
                next
            end
        
        end
      
        { result: validate_result, message: error_results }
    end 
    

end
  
module Kernel
    private
    include GlobalService 
end