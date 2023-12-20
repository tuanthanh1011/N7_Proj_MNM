class Api::V1::InterviewController < ApplicationController
  def index
    interviews = Interview.where(deletedAt: nil)

    # Phân trang, lọc, sắp xếp dữ liệu
    dataAfter = PaginationSortSearch.dataExploration(interviews, params, "")

    unless dataAfter[:success]
      render_response(dataAfter[:message], status: dataAfter[:status])
      return
    end

    # Chuyển đổi kết quả thành camel case
    result = CamelCaseConvert.convert_to_camel_case(dataAfter[:data].to_a)

    render_response("Hiển thị danh sách lịch phỏng vấn", data: result, status: 200)
  end

end