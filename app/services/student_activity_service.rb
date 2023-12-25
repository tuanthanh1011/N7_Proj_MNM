class StudentActivityService
    def self.getActivityByStudent (studentCode, params)
        begin
            student = Student.find_by(StudentCode: studentCode)
        
            # Kiểm tra mã sinh viên có tồn tại trên hệ thống?
            unless student
                return { success: false, message: "Sinh viên không tồn tại", status: 404}
            end

            unless StudentService.isVolunteer (studentCode)
                return { success: false, message: "Sinh viên không phải là sinh viên tình nguyện", status: 400}
            end
            
            # Thực hiện join 2 bảng
            student_activity = StudentActivity.joins(:activity)
            .select('activity.*')
            .where(StudentCode: studentCode)

            # Phân trang, lọc, sắp xếp dữ liệu
            processedData = PaginationSortSearch.dataExploration(student_activity, params, "ActivityName")

            puts "HIIH: ", processedData[:data].to_a
            # Xử lý lỗi khi thực hiện xử lý dữ liệu
            unless processedData[:success]
                return {success: false, message: processedData[:message], status: processedData[:status]}
            end

            # Chuyển dữ liệu đầu ra thành camel case
            result = CamelCaseConvert.convert_to_camel_case(processedData[:data].to_a)
            return {success: true, message: "Hiển thị danh sách hoạt động mà sinh viên tham gia", data: {listData: result, totalCount: processedData[:totalCount]}, status: 200}
        rescue StandardError => e
            return { success: false, message: e.message, status: 400 }
        end
    end
end
  