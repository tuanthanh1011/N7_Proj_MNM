class InterviewService
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
