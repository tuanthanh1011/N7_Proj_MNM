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

    # Hàm xử lý sau khi tạo mới rating thì update lại khóa ngoài
    def self.updateRatingCode (ratingCode, activityCode, studentCode)
        begin
            student_activity = StudentActivity.find_by(ActivityCode: activityCode, StudentCode: studentCode)
            if student_activity 

                # Kiểm tra đã đánh giá trước đó chưa
                result = isRatedActivity(activityCode, studentCode)

                # Xử lý lỗi
                unless result[:success]
                    return {success: false, message: result[:message], status: result[:status]}
                end
                # Kết thúc xử lý

                student_activity.update(RatingCode: ratingCode)
                student_activity.save
                return { success: true }
            else
                return {success: false, message: "Không tìm thấy hoạt động cùng sinh viên tương ứng", status: 404}
            end
        rescue StandardError => e
            return {success: false, message: "Có lỗi khi cập nhập mã đánh giá", status: 400}
        end
    end

    # Hàm kiểm tra sinh viên đã đánh giá 1 hoạt động trước đó chưa
    def self.isRatedActivity (activityCode, studentCode)
        begin
            student_activity = StudentActivity.find_by(ActivityCode: activityCode, StudentCode: studentCode)
            if student_activity.RatingCode == nil
                return { success: true }
            else
                return {success: false, message: "Sinh viên đã đánh giá hoạt động trước đó", status: 400}
            end
        rescue StandardError => e
            return {success: false, message: "Có lỗi khi kiểm tra trạng thái sinh viên đánh giá hoạt động", status: 400}
        end
    end
end
  