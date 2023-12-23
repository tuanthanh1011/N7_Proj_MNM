class ActivityService 

    # Hàm update
    def self.updateActivity(activityCode, payload)
        begin
        activity = Activity.find_by(ActivityCode: activityCode)
        
        if activity
            if activity.update(payload)
                activity.UpdatedAt = Time.now
                activity.save
                return { success: true, message: "Cập nhật hoạt động thành công" }
            else
                return { success: false, message: "Có lỗi khi cập nhật hoạt động", errors: activity.errors.full_messages, status: :unprocessable_entity }
            end
        else
            raise ActiveRecord::RecordNotFound.new("Không tìm thấy thông tin hoạt động")
        end

        rescue ActiveRecord::RecordNotFound => e
            return { success: false, message: e.message, status: 404 }
        rescue StandardError => e
            return { success: false, message: e.message, status: 400 }
        end
    end

    # Hàm tạo
  def self.createActivity(payload)
    begin
      activity = Activity.new(payload)
      activity.CreatedAt = Time.now
      if activity.save
        return { success: true, message: "Tạo mới hoạt động thành công", status: 200 }
      else
        return { success: false, message: "Có lỗi khi thêm hoạt động", errors: activity.errors.full_messages, status: :unprocessable_entity }
      end
    rescue StandardError => e
      return { success: false, message: e.message, status: 400 }
    end
  end

end