
class Api::V1::StudentsController < ApplicationController
  def index
    students = Student.all
    render_response("Hiển thị danh sách sinh viên", data: students, status: 200)
  end

  def show
    student = Student.find_by(StudentCode: params[:id])
    if student
      render_response("Hiển thị sinh viên theo mã sinh viên", data: student, status: 200)
    else 
      render_response("Không tìm thấy sinh viên", status: 404)
    end
  end

  def create
    student = Student.new(
      StudentCode: student_params[:StudentCode],
      StudentName: student_params[:StudentName],
      ClassName: student_params[:ClassName],
      PhoneNumber: student_params[:PhoneNumber],
      Email: student_params[:Email],
      AccountCode: student_params[:AccountCode],
      isVolunteerStudent: student_params[:isVolunteerStudent]
    )

    student.CreatedAt = Time.now
    
    begin
      if student.save
        render_response("Thêm mới sinh viên thành công", data: student, status: 201)
      else
        render_response("Có lỗi khi thêm sinh viên", status: 400)
      end
    rescue ActiveRecord::InvalidForeignKey => e
      custom_message = "Không tồn tại tài khoản"
      render_response(custom_message)
    end
    
  end

  def update
    student = Student.find_by(StudentCode: params[:id])

    begin
      if student
        if student.update(
          StudentName: student_params[:StudentName],
          ClassName: student_params[:ClassName],
          PhoneNumber: student_params[:PhoneNumber],
          Email: student_params[:Email],
          AccountCode: student_params[:AccountCode],
          isVolunteerStudent: student_params[:isVolunteerStudent])
          render_response("Cập nhật sinh viên thành công", data: student
        )
        student.UpdatedAt = Time.now
        else
          render_response("Có lỗi khi cập nhật sinh viên", nil, student.errors.full_messages)
        end
      else
        render_response("Sinh viên không tồn tại")
      end
    rescue ActiveRecord::InvalidForeignKey => e
      custom_message = "Không tồn tại tài khoản"
      render_response(custom_message)
    end
  end

  def destroy
    student = Student.find_by(StudentCode: params[:id])
    if student
      student.destroy
      render_response("Xóa sinh viên thành công")
    else 
      render_response("Sinh viên không tồn tại")
    end
  end

  def search
    studentCode = params[:StudentCode]
    studentName = params[:StudentName]
    className = params[:ClassName]

    student = Student.find_by(
      StudentCode: studentCode,
      StudentName: studentName,
      ClassName: className
    )
    if student
      render_response("Tìm kiếm sinh viên", data: student, status: 200)
    else 
      render_response("Sinh viên không tồn tại", status: 404)
    end
  end

  private

  def student_params
    params.require(:student).permit([
      :StudentCode,
      :StudentName,
      :ClassName,
      :PhoneNumber,
      :Email,
      :AccountCode,
      :isVolunteerStudent
    ])
  end

end
