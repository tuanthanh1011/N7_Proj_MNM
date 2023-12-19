require "./app/services/student_service.rb"
require "./app/services/volunteer_account_service.rb"

class Api::V1::Admin::StudentInterviewAdminController < ApplicationController
  def index
    student_interview = StudentInterview.where(ResultInterview: nil).all.to_a
    result = CamelCaseConvert.convert_to_camel_case(student_interview)
    render_response("Hiển thị danh sách sinh viên tham gia phỏng vấn", data: result, status: 200)
  end

  def update
    # Lấy dữ liệu gửi trong body
    studentCode = params[:id]
    resultInterview = params[:resultInterview]

    # Tìm sinh viên với mã SV tương ứng
    updated_interview = StudentInterview.find_by(StudentCode: studentCode, ResultInterview: nil)

    if updated_interview
      StudentInterview.where(StudentCode: studentCode, ResultInterview: nil).update_all(ResultInterview: resultInterview, UpdatedAt: Time.now)

      # Kiểm tra nếu sinh viên pass pvan thì thực hiện mã
      if !!resultInterview == true
        # Cập nhật trạng thái sinh viên (table: student -> isVolunteer: true)
        resultUpdateVolunteer = StudentService.updateVolunteer(updated_interview.StudentCode)

        unless resultUpdateVolunteer[:success]
          render_response(resultUpdateVolunteer[:message], status: 400)
          return
        end

        # Tự động tạo tài khoản cho sv pass pvan
        resultCreateAccount = VolunteerAccountService.createAccount(updated_interview.StudentCode)

        unless resultCreateAccount[:success]
          render_response(resultCreateAccount[:message], status: 400)
          return
        end

        # Lấy ra accountCode của tài khoản vừa tạo
        accountCode = resultCreateAccount[:accountCode]

        # Cập nhật mã tài khoản vào bảng student
        resultUpdateAccountCode = StudentService.updateAccountCode(updated_interview.StudentCode, accountCode)

        unless resultUpdateAccountCode[:success]
          render_response(resultUpdateAccountCode[:message], status: 400)
          return
        end

      end

      render_response("Cập nhật thông tin phỏng vấn thành công", status: 200)
    else
      render_response("Sinh viên hiện không nằm trong danh sách phỏng vấn", status: 404)
    end
  end

end
