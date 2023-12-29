class Api::V1::StudentAdminController < ApplicationController

  # Hàm xử lý lấy tất cả sinh viên
    def index
      # Gọi hàm lấy tất cả sinh viên (truyền params: lọc, sắp xếp, phân trang)
      result = StudentAdminService.getAllStudentService (params)
      
      # Xử lý lỗi
      unless result[:success]
        render_response(result[:message], status: result[:status])
        return
      end

      render_response(result[:message], data: result[:data], status: result[:status])
    end

    # Hàm xử lý lấy tất cả sinh viên tình nguyện
    def show_volunteer
        # Gọi hàm lấy tất cả sinh viên tình nguyện (truyền params: lọc, sắp xếp, phân trang)
      result = StudentAdminService.getAllStudentVolunteerService (params)
      
      # Xử lý lỗi
      unless result[:success]
        render_response(result[:message], status: result[:status])
        return
      end

      render_response(result[:message], data: result[:data], status: result[:status])
    end

    # Hàm xóa sinh viên tình nguyện
    def delete_student_volunteer 
      studentCode = params[:studentCode]

      result = StudentAdminService.deleteVolunteerService(studentCode);

      # Xử lý lỗi
      unless result[:success]
        render_response(result[:message], status: result[:status])
        return
      end

      render_response(result[:message], status: 200)
    end

end
