class StudentActivityService
    def self.createStudentActivity
        begin
            # Xử lý kiểm tra đã là SVTN ?
            if !StudentService.isVolunteer(studentCode)
                render_response("Bạn không phải là sinh viên tình nguyện", status: 400)
                return
            end   
            student_activity = StudentActivity.new(payload)
            student_activity.CreatedAt = Time.now
            if student_activity.save
              return { success: true, message: "Thêm sinh viên tham gia hoạt động thành công", status: 200 }
            else
              return { success: false, message: "Có lỗi khi thêm sinh viên tham gia", errors: activity.errors.full_messages, status: :unprocessable_entity }
            end
            
        rescue ActiveRecord::InvalidForeignKey => e
            return { success: false, message: "Dữ liệu không hợp lệ", status: 400}
        rescue StandardError => e
            return { success: false, message: e.message, status: 400 }
        end
    end
end