class InterviewService
    def self.createRating (payload)
        begin 
            rating = Rating.new(RatingStart: ratingStar, Description: description)
            rating.CreatedAt = Time.now
            if rating.save
              return { success: true, message: "Tạo mới đánh giá thành công", status: 200 }
            else
              return { success: false, message: "Có lỗi khi thêm đánh giá", errors: activity.errors.full_messages, status: :unprocessable_entity }
            end
        rescue StandardError => e
            return { success: false, message: e.message, status: 400 }
        end
    end
end
  