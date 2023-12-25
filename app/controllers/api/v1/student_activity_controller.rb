class Api::V1::StudentActivityController < ApplicationController
    def index 
        studentCode = params[:id]
        # Gọi hàm lấy tất cả hoạt động theo sinh viên (truyền params: lọc, sắp xếp, phân trang)
        result = StudentActivityService.getActivityByStudent(studentCode, params)
        
        # Xử lý lỗi
        unless result[:success]
            render_response(result[:message], status: result[:status])
            return
        end

        render_response(result[:message], data: result[:data], status: result[:status])
    end
end
