class InterviewService

  # Hàm lấy tất cả phỏng vấn
  def self.getAllInterviewService (params) 
    begin

      interviews = Interview.where(deletedAt: nil)

      # Phân trang, lọc, sắp xếp dữ liệu
      processedData = PaginationSortSearch.dataExploration(interviews, params, "InterviewCode")

      unless processedData[:success]
        return {success: false, message: processedData[:message], status: processedData[:status]}
      end

      # Chuyển đổi kết quả thành camel case
      result = CamelCaseConvert.convert_to_camel_case(processedData[:data].to_a)

      return { success: true, message: "Hiển thị danh sách lịch phỏng vấn", data: {listData: result, totalCount: processedData[:totalCount]}, status: 200}

    rescue StandardError => e
      return { success: false, message: e.message, status: 400 }
    end
  end


  # Hàm cập nhật sl apply
  def self.updateQtt(interviewCode)
    begin
      interview = Interview.find_by(InterviewCode: interviewCode)
      
      if interview
        quantity_after = interview.Quantity + 1
        
        if quantity_after > interview.QuantityMax
          raise StandardError.new("Số lượng tham gia đã đầy. Vui lòng quay lại sau")
        end

        if interview.update(Quantity: quantity_after)
          interview.update(UpdatedAt: Time.now)
          return { success: true, message: "Cập nhật thành công" }

        else
          raise StandardError.new("Lỗi khi cập nhật phỏng vấn")
        end

      else
        raise StandardError.new("Không tìm thấy thông tin phỏng vấn")
      end
      
    rescue StandardError => e
      return { success: false, message: e.message }
    ensure
    end
  end

end
