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
        render_response("Hiển thị danh sách sinh viên", data: {listData: result, totalCount: dataAfter[:totalCount]}, status: 200)
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
        
        render_response("Hiển thị danh sách sinh viên tình nguyện",data: {listData: result, totalCount: dataAfter[:totalCount]}, status: 200)
    end

    def delete_student_volunteer 
      studentCode = params[:id]

      result = StudentService.update_del_volunteer(studentCode);

      puts result
      unless result[:success]
        render_response(result[:message], status: result[:status])
        return
      end

      render_response(result[:message], status: 200)
    end

end
