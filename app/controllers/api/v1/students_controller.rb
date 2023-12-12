class Api::V1::StudentsController < ApplicationController
  def index
    students = Student.all
    render_response(200, "Get all student", students)
  end

  def show
    student = Student.find_by(StudentCode: params[:id])
    if student
      render_response(200, "Get student by id", student)
    else 
      render_response(404, "Student not found", student)
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

    if student.save
      render_response(201, "Create a student", student)
    else 
      render_response(422, "Error creating...", student)
    end
  end

  def update
    student = Student.find_by(StudentCode: params[:id])
    if student
      student.update(
        StudentName: params[:StudentName], 
        ClassName: params[:ClassName], 
        PhoneNumber: params[:PhoneNumber], 
        Email: params[:Email], 
        AccountCode: params[:AccountCode], 
        isVolunteerStudent: params[:isVolunteerStudent]
      )
      render_response(200, "Update student by id", student)
    else 
      render_response(404, "Student not found", student)
    end
  end

  def destroy
    student = Student.find_by(StudentCode: params[:id])
    if student
      student.destroy
      render_response(204, "Delete student by id", student)
    else 
      render_response(404, "Student not found", student)
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
