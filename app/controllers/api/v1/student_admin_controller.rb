class Api::V1::StudentAdminController < ApplicationController
    def index
        students = Student.all.to_a
        result = CamelCaseConvert.convert_to_camel_case(students)
        render_response("Hiển thị danh sách sinh viên", data: result, status: 200)
    end

    def show_volunteer
        students = Student.where.not(isVolunteerStudent: false).to_a
        result = CamelCaseConvert.convert_to_camel_case(students)
        render_response("Hiển thị danh sách sinh viên tình nguyện", data: result, status: 200)
    end

end
