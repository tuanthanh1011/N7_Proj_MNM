module PaginationSortSearch
  def self.dataExploration(data, params, paramFilter)
    p data
    begin
      # Lọc theo điều kiện nếu có tham số 'filter' được truyền vào
      if params[:search].present? && paramFilter.present?
        data = data.where("LOWER(#{paramFilter}) LIKE ?", "%#{params[:search].downcase}%")
      end
      
      total_count = data.length
      # Phân trang nếu có tham số 'page' được truyền vào
      if params[:page].present?
        # Phân trang với số lượng bản ghi truyền từ params (mặc định 5)
        data_per_page = params[:limit].present? ? params[:limit].to_i : 5
        page_number = params[:page].to_i
        
        data = data.page(page_number).per(data_per_page)
      end
      
      if params[:sort].present?
        param_sort = convert_camelcase_to_pascalcase(params[:sort])
        
        order_sort = params[:order].present? ? params[:order].to_sym : :asc
        begin
          data = data.order(param_sort => order_sort)
           
          # Sử dụng data nhằm có thể ném ra ngoại lệ StatementInvalid
          puts data
        rescue ActiveRecord::StatementInvalid => e
          return { success: false, message: "Trường cần sắp xếp không tồn tại", status: 400 }
        end
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
