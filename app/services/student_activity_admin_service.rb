class StudentActivityAdminService
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
 
    # Hàm thêm sinh viên vào hoạt động bất kỳ
    def self.createStudentActivityService(payload, activityCode)
        student_codes = payload[:StudentCode]
      
        validate_result = validate_input(student_codes, activityCode)
      
        unless isExistActivity(activityCode)
            return { success: false, message: "Hoạt động không tồn tại", status: 404 }
        end

        if (validate_result[:result])

            resultDelete = deleteStudentActivityService(activityCode)

            # Xử lý lỗi khi xóa 
            unless resultDelete[:success]
                return { success: false, message: resultDelete[:message], status: resultDelete[:status]}
            end

            student_codes.each do |studentCode|
                begin
                    student_activity = StudentActivity.new(payload.merge(StudentCode: studentCode, ActivityCode: activityCode, RatingCode: nil))
            
                    if student_activity.save
                    # Thêm thành công
                    else
                        return { success: false, message: "Có lỗi khi thêm sinh viên tham gia hoạt động", errors: student_activity.errors.full_messages, status: :unprocessable_entity }
                    end
            
                rescue StandardError => e
                  return { success: false, message: "Có lỗi khi thêm sinh viên tham gia hoạt động", status: 400 }
                end

            end
        else
            return { success: false, message: "Dữ liệu không hợp lệ", errors: validate_result[:message], status: 400 }
        end
      
        return { success: true, message: "Thêm sinh viên vào hoạt động thành công" }
    end

    def self.deleteStudentActivityService(activityCode)
        begin
            # Lấy ra tất cả sinh viên tham gia hoạt động có mã hoạt động tương ứng
            student_activity = StudentActivity.where("ActivityCode = ?", activityCode)
      
            # Xóa tất cả bản ghi
            student_activity.delete_all
      
            return { success: true, message: "Xóa sinh viên khỏi hoạt động thành công" }
      
        rescue StandardError => e
            return { success: false, message: "Có lỗi khi xóa sinh viên tham gia hoạt động #{e.message}", status: 400 }
        end
    end
      
    # Hàm lấy ra sinh viên đang tham gia theo mã hoạt động
    def self.getStudentByActivity (params, activityCode)
        begin
            # Thực hiện join 2 bảng
            student_activity = StudentActivity.joins(:student)
            .select('student_activity.*, student.studentCode, student.studentName, student.className')
            .where(ActivityCode: activityCode).all

            # Phân trang, lọc, sắp xếp dữ liệu
            processedData = PaginationSortSearch.dataExploration(student_activity, params, "StudentName")

            # Xử lý lỗi khi thực hiện xử lý dữ liệu
            unless processedData[:success]
                return {success: false, message: processedData[:message], status: processedData[:status]}
            end

            # Chuyển dữ liệu đầu ra thành camel case
            result = CamelCaseConvert.convert_to_camel_case(processedData[:data].to_a)
            return {success: true, message: "Hiển thị sinh viên theo hoạt động", data: {listData: result, totalCount: processedData[:totalCount]}, status: 200}
        rescue StandardError => e
            return { success: false, message: e.message, status: 400 }
        end
    end

    # Hàm kiểm tra sinh viên đã tham gia hoạt động đó từ trước hay chưa
    def self.isJoinedActivity(student_code, activity_code)
        student_activity = StudentActivity.find_by(StudentCode: student_code, ActivityCode: activity_code)
        return !student_activity.nil?
    end

    # Hàm kiểm tra activity code có chính xác hay không
    def self.isExistActivity(activity_code)
        activity = Activity.find_by(ActivityCode: activity_code)
        return !activity.nil?
    end 

    # Hàm kiểm tra có sinh viên nào đang tham gia hoạt động không
    def self.isStudentJoin(activity_code)
        student_activity = StudentActivity.find_by(ActivityCode: activity_code)
        return !student_activity.nil?
    end
end