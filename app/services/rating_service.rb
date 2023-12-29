class RatingService
    def self.createRating (payload, activityCode, studentCode)
        ratingStar = payload[:RatingStar]
        description = payload[:Description]

        begin 
            resultCheckStudentActivity = StudentActivityService.checkStudentActivity(activityCode, studentCode)
          
            # Xử lý lỗi khi sinh viên đã đánh giá hoạt động trước đó
            unless resultCheckStudentActivity[:success]
              return {success: false, message: resultCheckStudentActivity[:message], status: resultCheckStudentActivity[:status]}
            end

            rating = Rating.new(RatingStar: ratingStar, Description: description)
            rating.CreatedAt = Time.now
            if rating.save

              # Thêm mã đánh giá vào bảng student_activity tương ứng
              result = StudentActivityService.updateRatingCode(rating.RatingCode, activityCode, studentCode)
              # Xử lý lỗi
              unless result[:success]
                return {success: false, message: result[:message], status: result[:status]}
              end

              return { success: true, message: "Tạo mới đánh giá thành công", status: 200 }
            else
              return { success: false, message: "Có lỗi khi thêm đánh giá", errors: rating.errors.full_messages, status: :unprocessable_entity }
            end
        rescue StandardError => e
            return { success: false, message: e.message, status: 400 }
        end
    end

    def self.getRatingByActivity(activityCode, params)
      begin
        rating = StudentActivity.joins(:rating).joins(:student)
        .select('student_activity.*, student.studentCode, student.studentName, student.className, rating.ratingCode, rating.ratingStar, rating.description, rating.createdAt')
        .where(activityCode: activityCode).all
  
        if rating
          # Phân trang, lọc, sắp xếp dữ liệu
          processedData = PaginationSortSearch.dataExploration(rating, params, "StudentName")
    
          unless processedData[:success]
            return {success: false, message: processedData[:message], status: processedData[:status]}
          end
          # Chuyển đổi kết quả thành camel case
          result = CamelCaseConvert.convert_to_camel_case(processedData[:data].to_a)
  
          return { success: true, message: "Hiển thị danh sách đánh giá theo hoạt động", data: {listData: result, totalCount: processedData[:totalCount]}, status: 200}
        else 
          return {success: false, message: "Không tìm thấy hoạt động", status: 400}
        end 
      rescue StandardError => e
          return { success: false, message: e.message, status: 400 }
      end
    end

end
  