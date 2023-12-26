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
end
  
module Kernel
    private
    include GlobalService 
end