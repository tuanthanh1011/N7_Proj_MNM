module PaginationSortSearch
  def self.dataExploration(data, params, paramFilter)
    begin
      total_count = data.length
      # Lọc theo điều kiện nếu có tham số 'filter' được truyền vào
      if params[:search].present? && paramFilter.present?
        data = data.where("LOWER(#{paramFilter}) LIKE ?", "%#{params[:search].downcase}%")
      end
    
      # Phân trang nếu có tham số 'page' được truyền vào
      if params[:page].present?
        # Phân trang với số lượng bản ghi truyền từ params (mặc định 5)
        data_per_page = params[:limit].present? ? params[:limit].to_i : 5
        page_number = params[:page].to_i
    
        data = data.page(page_number).per(data_per_page)
      end

      # Sắp xếp theo trường studentName nếu có tham số 'sort' là 'studentName'
      if params[:sort].present?
        param_sort = convert_camelcase_to_pascalcase(params[:sort])

        #  #Kiểm tra nếu trường cần sắp xếp không tồn tại thì trả về lỗi
        # if !data.column_names.include?(param_sort)
        #   return { success: false, message: "Trường cần sắp xếp không tồn tại", status: 400 }
        # end

        order_sort = params[:order].present? ? params[:order].to_sym : :asc
        data = data.order(param_sort => order_sort)
      end
    rescue StandardError => e
      return { success: false, message: "Tham số không chính xác", status: 400 }
    end

    return { success: true, data: data, totalCount: total_count}
  end

  private

  def convert_camelcase_to_pascalcase(str)
    str.gsub(/(?:\A|_)([a-z\d])/) { $1.upcase }
  end
end

module Kernel
  private
  include PaginationSortSearch
end
