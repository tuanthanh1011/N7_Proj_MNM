class StudentAdminService

    # Hàm lấy tất cả sinh viên
    def self.getAllStudentService (params) 
        begin
            # Lấy tất cả sinh viên
            students = Student.all

            # Phân trang, lọc, sắp xếp dữ liệu
            processedData = PaginationSortSearch.dataExploration(students, params, "StudentName")

            unless processedData[:success]
                return {success: false, message: processedData[:message], status: processedData[:status]}
            end

            # Chuyển đổi kết quả thành camel case
            result = CamelCaseConvert.convert_to_camel_case(processedData[:data].to_a)

            return { success: true, message: "Hiển thị danh sách sinh viên", data: {listData: result, totalCount: processedData[:totalCount]}, status: 200}

        rescue StandardError => e
            return { success: false, message: e.message, status: 400 }
        end
    end

    # Hàm lấy tất cả sinh viên
    def self.getAllStudentVolunteerService (params) 
        begin
            # Lấy tất cả sinh viên tình nguyện
            students = Student.where.not(isVolunteerStudent: false)

            # Phân trang, lọc, sắp xếp dữ liệu
            processedData = PaginationSortSearch.dataExploration(students, params, "StudentName")

            unless processedData[:success]
                return {success: false, message: processedData[:message], status: processedData[:status]}
            end

            # Chuyển đổi kết quả thành camel case
            result = CamelCaseConvert.convert_to_camel_case(processedData[:data].to_a)

            return { success: true, message: "Hiển thị danh sách sinh viên tình nguyện", data: {listData: result, totalCount: processedData[:totalCount]}, status: 200}

        rescue StandardError => e
            return { success: false, message: e.message, status: 400 }
        end
    end

    # Hàm xóa sinh viên tình nguyện đồng thời xóa luôn tài khoản của sinh viên 
    def self.deleteVolunteerService(studentCode)
        begin
            student = Student.find_by(StudentCode: studentCode, isVolunteerStudent: true)
          
            # Kiểm tra sinh viên có tồn tại không, nếu không trả ra message lỗi
            if student
                # Lấy mã tài khoản để xóa tài khoản
                accountCode = student.AccountCode
                
                # Set lại giá trị isVolunteer và accountCode
                if student.update(AccountCode: nil, isVolunteerStudent: false)
                    student.update(UpdatedAt: Time.now)
        
                    # Thực hiện xóa tài khoản
                    result = VolunteerAccountService.deleteAccount(accountCode)
        
                    # Xử lý lỗi khi xóa tài khoản
                    unless result[:success]
                        return { success: false, message: result[:message], status: result[:status]}
                    end
        
                    return { success: true, message: "Xóa sinh viên tình nguyện thành công", status: 200 }
                else
                    return { success: false, message: "Có lỗi khi xóa sinh viên tình nguyện", status: 404 }
                end
            else
                return { success: false, message: "Sinh viên tình nguyện không tồn tại", status: 404 }
            end
        rescue StandardError => e
          return { success: false, message: "Có lỗi khi xóa sinh viên tình nguyện: #{e.message}", status: 400 }
        end
    end

end