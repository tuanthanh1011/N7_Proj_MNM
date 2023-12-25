class Activity < ApplicationRecord
    self.table_name = 'activity'

    has_one :student_interview, foreign_key: 'ActivityCode', primary_key: 'ActivityCode'

    validate do |activity|
        # Kiểm tra các điều kiện bổ sung chỉ khi tất cả ba trường đã nhập
        activity.errors.add(:base, "Trường tên hoạt động không được để trống!") if activity.ActivityName.blank?
        activity.errors.add(:base, "Trường ngày bắt đầu không được để trống!") if self.BeginingDate_before_type_cast.blank?
        activity.errors.add(:base, "Trường người quản lý không được để trống!") if activity.Manager.blank?
        activity.errors.add(:base, "Trường kinh phí hỗ trợ không được để trống!") if self.SupportMoney_before_type_cast.blank?
        activity.errors.add(:base, "Trường mô tả không được để trống!") if activity.Description.blank?
        
        puts self.BeginingDate_before_type_cast
        puts self.SupportMoney_before_type_cast
        puts valid_date_format?(self.BeginingDate_before_type_cast)

        if activity.ActivityName.present? && activity.SupportMoney.present? && self.BeginingDate_before_type_cast.present? && activity.Manager.present? && activity.Description.present?
            activity.errors.add(:base, "Kinh phí hỗ trợ phải là 1 số!") unless valid_numeric?(self.SupportMoney_before_type_cast)
            activity.errors.add(:base, "Ngày bắt đầu không đúng định dạng!") unless valid_date_format?(self.BeginingDate_before_type_cast)
      end
    end
  
    private
  
    def valid_date_format?(date_str)
        return true if date_str.is_a?(Date)
      
        begin
          Date.parse(date_str)
          return true
        rescue => e
          return false
        end
    end

    def valid_numeric?(value)
        Float(value) rescue false
    end
end
