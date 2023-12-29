class InterviewAdminService

    # Hàm lấy ra tất cả phỏng vấn
    def self.getAllInterviewService (params)
        interviews = Interview.all

        # Phân trang, lọc, sắp xếp dữ liệu
        processedData = PaginationSortSearch.dataExploration(interviews, params, "InterviewCode")

        unless processedData[:success]
            return { success: false, message: processedData[:message], status: processedData[:status] }
        end

        # Chuyển đổi kết quả thành camel case
        result = CamelCaseConvert.convert_to_camel_case(processedData[:data].to_a)

        return { success: true, message: "Hiển thị danh sách lịch phỏng vấn", data: {listData: result, totalCount: processedData[:totalCount]}, status: 200}
    end

    # Hàm xóa mềm phỏng vấn
    def self.deleteInterviewService(arrInterviewCode)
        begin
        validate_result = validate_input(arrInterviewCode)
    
        if validate_result[:result]
            arrInterviewCode.each do |interviewCode|
            interview = Interview.find_by(InterviewCode: interviewCode)
            interview.update(DeletedAt: Time.now) if interview
            end
            return { success: true, message: "Xóa phỏng vấn thành công", status: 200 }
        else
            return { success: false, message: validate_result[:message], status: 400 }
        end
        rescue StandardError => e
            return { success: false, message: e.message, status: 400 }
        end
    end
  

    # Hàm update phỏng vấn
    def self.updateInterviewService(interviewCode, payload)
        begin
            interview = Interview.find_by(InterviewCode: interviewCode)
            
            if interview

                 # Kiểm tra nếu payload chứa quantityMax thì không cho cập nhật nếu đang có sv đăng ky
                if payload.key?('QuantityMax')
                     # Kiểm tra nếu đã có sinh viên apply thì không cho cập nhật
                    resultCheckQuantity = isStudentExist(interviewCode)
                    unless resultCheckQuantity
                        return { success: false, message: "Không thể cập nhật số lượng khi đang có sinh viên đăng ký", status: 400}
                    end
                    # Kết thúc mã kiểm tra
                end

                if interview.update(payload)
                    interview.UpdatedAt = Time.now
                    interview.save
                    return { success: true, message: "Cập nhật phỏng vấn thành công", status: 200 }
                else
                    return { success: false, message: "Có lỗi khi cập nhật phỏng vấn", errors: interview.errors.full_messages, status: :unprocessable_entity }
                end
            else
                return { success: false, message: "Không tìm thấy thông tin phòng phỏng vấn", status: 404}
            end
        rescue StandardError => e
            return { success: false, message: e.message, status: 400 }
        end
    end

    # Hàm tạo mới phỏng vấn
    def self.createInterviewService(payload)
        begin
            interview = Interview.new(payload)
            interview.CreatedAt = Time.now
        
            if interview.save
                return { success: true, message: "Tạo mới phỏng vấn thành công", status: 200 }
            else
                return { success: false, message: "Có lỗi khi thêm phỏng vấn", errors: interview.errors.full_messages, status: :unprocessable_entity }
            end
        rescue StandardError => e
            return { success: false, message: e.message, status: 400 }
        end
    end

    # Hàm kiểm tra đã có sinh viên apply chưa
    def self.isStudentExist (interviewCode)
        interview = Interview.find_by(InterviewCode: interviewCode)

        if interview.Quantity > 0
            return false
        end
        return true
    end

     # Hàm kiểm tra mảng mã hoạt động đầu vào có lỗi không
     def self.validate_input(arr_interview_code)
        error_results = []
        validate_result = true
      
        arr_interview_code.each do |interview_code|
          interview = Interview.find_by(InterviewCode: interview_code, DeletedAt: nil)
      
          # Kiểm tra mã phỏng vấn có tồn tại trên hệ thống?
          unless interview
            error_results << "Không tồn tại mã phỏng vấn #{interview_code}"
            validate_result = false
            next
          end
      
          # Kiểm tra phỏng vấn có sinh viên nào tham gia chưa
          if interview.Quantity > 0
            error_results << "Phỏng vấn #{interview_code} đã có sinh viên tham gia. Không thể xóa"
            validate_result = false
            next
          end
        end
      
        { result: validate_result, message: error_results }
    end

end