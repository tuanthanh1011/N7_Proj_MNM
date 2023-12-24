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
    def self.deleteInterviewService (interviewCode)
        begin
            interview = Interview.find_by(InterviewCode: interviewCode, DeletedAt: nil)
                
            if interview
                if interview.update(DeletedAt: Time.now)
                    return { success: true, message: "Xóa phỏng vấn thành công" }
                else
                    return { success: false, message: "Có lỗi khi xóa phỏng vấn", status: 400 }
                end
            else
                return { success: false, message: "Không tìm thấy thông tin phỏng vấn", status: 404 }
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

end