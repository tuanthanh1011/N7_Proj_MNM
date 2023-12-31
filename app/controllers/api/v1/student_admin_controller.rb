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

    # Hàm xóa nhiều sinh viên tình nguyện
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

    # Hàm xóa một sinh viên tình nguyện
    def delete_student_volunteer_one
      studentCode = params[:id]

      result = StudentAdminService.deleteVolunteerServiceOne(studentCode);

      # Xử lý lỗi
      unless result[:success]
        render_response(result[:message], status: result[:status])
        return
      end

      render_response(result[:message], status: 200)
    end

    # Hàm xuất file
    require 'spreadsheet'
    def export_file
      # Tạo một workbook mới
      workbook = Spreadsheet::Workbook.new
    
      # Tạo một worksheet trong workbook
      worksheet = workbook.create_worksheet(name: 'Sheet1')
    
      # Thêm tiêu đề cho worksheet
      worksheet.row(0).concat %w{Mã_sinh_viên Tên_sinh_viên Lớp Số_điện_thoại Email Mã_tài_khoản Ngày_tạo}
    
      # Truy vấn cơ sở dữ liệu để lấy dữ liệu
      data_from_db = Student.where(isVolunteerStudent: true).all
    
      # Thêm dữ liệu từ cơ sở dữ liệu vào worksheet
      data_from_db.each_with_index do |data, index|
        worksheet.row(index + 1).concat [data.StudentCode, data.StudentName, data.ClassName, data.PhoneNumber, data.Email, data.AccountCode, data.CreatedAt]
      end
    
      # Tạo một string để lưu trữ nội dung của workbook
      excel_data = StringIO.new
      workbook.write(excel_data)
      excel_data.rewind
    
      # Trả về tệp Excel dưới dạng response để tải xuống
      send_data(
        excel_data.read,
        type: 'application/vnd.ms-excel',
        filename: 'Danh sách sinh viên tình nguyện.xls'
      )
    end
end
