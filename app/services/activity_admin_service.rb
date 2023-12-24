class ActivityAdminService 
    def self.getAllActivities (params)
       begin

            activities = Activity.all

            # Phân trang, lọc, sắp xếp dữ liệu
            processedData = PaginationSortSearch.dataExploration(activities, params, "ActivityName")

            # Xử lý lỗi khi thực hiện xử lý dữ liệu
            unless processedData[:success]
                return {success: false, message: processedData[:message], status: processedData[:status]}
            end

            # Chuyển dữ liệu đầu ra thành camel case
            result = CamelCaseConvert.convert_to_camel_case(processedData[:data].to_a)
            return {success: true, message: "Hiển thị danh sách hoạt động", data: {listData: result, totalCount: processedData[:totalCount]}, status: 200}
        rescue StandardError => e
            return { success: false, message: e.message, status: 400 }
        end
    end

    def self.getActivityById (activityCode)
        begin
            activity = Activity.find_by(ActivityCode: activityCode)
            if activity
                return {success: true, message: "Hiển thị hoạt động theo mã hoạt động", data: activity, status: 200}
            else 
                return {success: false, message: "Không tìm thấy hoạt động", status: 400}
            end 
        rescue StandardError => e
            return { success: false, message: e.message, status: 400 }
        end
    end

    def self.deleteActivity (activityCode)
        begin
            activity = Activity.find_by(ActivityCode: activityCode)
            if activity
                activity.destroy
                return {success: true, message: "Xóa hoạt động thành công",status: 200}
            else 
                return {success: false, message: "Hoạt động không tồn tại", status: 400}
            end
        rescue StandardError => e
            return { success: false, message: e.message, status: 400 }
        end
    end
end