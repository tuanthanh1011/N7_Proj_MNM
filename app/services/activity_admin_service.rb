class ActivityAdminService 
    def self.getAllActivities (params)
        activities = Activity.all

        # Phân trang, lọc, sắp xếp dữ liệu
        processedData = PaginationSortSearch.dataExploration(activities, params, "ActivityName")

        # Xử lý lỗi khi thực hiện xử lý dữ liệu
        unless processedData[:success]
            return {success: false, message: processedData[:message], status: processedData[:status]}
        end

        # Chuyển dữ liệu đầu ra thành camel case
        result = CamelCaseConvert.convert_to_camel_case(processedData[:data].to_a)
        return {success: true, data: {listData: result, totalCount: dataAfter[:totalCount]}, status: 200}
    end

end