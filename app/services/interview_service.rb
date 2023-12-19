class InterviewService

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

  # Hàm xóa
  def self.deleteInterview(interviewCode)
    begin
      interview = Interview.find_by(InterviewCode: interviewCode, DeletedAt: nil)
      
      if interview
        if interview.update(DeletedAt: Time.now)
          return { success: true, message: "Xóa phỏng vấn thành công" }
        else
          raise StandardError.new("Lỗi khi xóa phỏng vấn")
        end

      else
        raise ActiveRecord::RecordNotFound.new("Không tìm thấy thông tin phỏng vấn")
      end
      
    rescue ActiveRecord::RecordNotFound => e
      return { success: false, message: e.message, status: 404 }
    rescue StandardError => e
      return { success: false, message: e.message, status: 400 }
    ensure
    end
  end

  # Hàm update
  def self.updateInterview(interviewCode, payload)
    begin
      interview = Interview.find_by(InterviewCode: interviewCode)
      
      if interview
        if interview.update(payload)
          interview.UpdatedAt = Time.now
          interview.save
          return { success: true, message: "Cập nhật phỏng vấn thành công" }
        else
          raise StandardError.new("Lỗi khi cập nhật phỏng vấn")
        end
      else
        raise ActiveRecord::RecordNotFound.new("Không tìm thấy thông tin phòng phỏng vấn")
      end
      
    rescue ActiveRecord::RecordNotFound => e
      return { success: false, message: e.message, status: 404 }
    rescue StandardError => e
      return { success: false, message: e.message, status: 400 }
    end
  end

  def self.createInterview(payload)
    begin
      interview = Interview.new(payload)
      interview.CreatedAt = Time.now
  
      if interview.save
        return { success: true, message: "Cập nhật phỏng vấn thành công" }
      else
        return { success: false, message: "Có lỗi khi thêm phỏng vấn", errors: interview.errors.full_messages, status: :unprocessable_entity }
      end
    rescue StandardError => e
      return { success: false, message: e.message, status: 400 }
    end
  end
  

end
