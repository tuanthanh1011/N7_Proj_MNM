class Interview < ApplicationRecord
  self.table_name = 'interview'
  
  validate do |interview|
      interview.errors.add(:base, "Trường số lượng không được để trống!") if interview.QuantityMax.blank?
      interview.errors.add(:base, "Trường phòng phỏng vấn không được để trống!") if interview.InterviewRoom.blank?
      interview.errors.add(:base, "Trường số lượng ban đầu không được để trống!") if interview.Quantity.blank?
      interview.errors.add(:base, "Trường ngày phỏng vấn không được để trống!") if self.InterviewDate_before_type_cast.blank?
      
      if interview.QuantityMax.present? && interview.InterviewRoom.present? && self.InterviewDate_before_type_cast.present? && interview.Quantity.present?
        interview.errors.add(:base, "Số lượng ban đầu phải lớn hơn hoặc bằng 0!") unless interview.Quantity.to_i >= 0
        interview.errors.add(:base, "Số lượng phải lớn hơn 0!") unless interview.QuantityMax.to_i > 0
        interview.errors.add(:base, "Ngày phỏng vấn không đúng định dạng!") unless valid_date_format?(self.InterviewDate_before_type_cast)
   
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

end