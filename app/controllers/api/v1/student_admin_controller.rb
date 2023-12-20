class Api::V1::StudentAdminController < ApplicationController
    def index
        # Lấy tất cả sinh viên
        students = Student.all
    
        # Phân trang, lọc, sắp xếp dữ liệu
        dataAfter = PaginationSortSearch.dataExploration(students, params, "StudentName")

        unless dataAfter[:success]
          render_response(dataAfter[:message], status: dataAfter[:status])
          return
        end
    
        # Chuyển đổi kết quả thành camel case
        result = CamelCaseConvert.convert_to_camel_case(dataAfter[:data].to_a)
    
        # Render kết quả
        render_response("Hiển thị danh sách sinh viên", data: result, status: 200)
      end

    def show_volunteer
        students = Student.where.not(isVolunteerStudent: false)
      
        # Phân trang, lọc, sắp xếp dữ liệu
        dataAfter = PaginationSortSearch.dataExploration(students, params, "StudentName")

        unless dataAfter[:success]
          render_response(dataAfter[:message], status: dataAfter[:status])
          return
        end

        # Chuyển đổi kết quả thành camel case
        result = CamelCaseConvert.convert_to_camel_case(dataAfter[:data].to_a)
        
        render_response("Hiển thị danh sách sinh viên tình nguyện", data: result, status: 200)
    end

end
