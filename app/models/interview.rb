class Interview < ApplicationRecord
    self.table_name = 'interview'
  
    validate :validate_each
  
    validate do |interview|
      interview.errors.add(:base, "Trường số lượng không được để trống!") if interview.QuantityMax.blank?
      interview.errors.add(:base, "Số lượng phải lớn hơn 0") unless interview.QuantityMax.to_i > 0
      interview.errors.add(:base, "Số lượng ban đầu phải lớn hơn hoặc bằng 0") unless interview.Quantity.to_i >= 0
      interview.errors.add(:base, "Trường ngày phỏng vấn không được để trống!") if interview.InterviewDate.blank?
    end
  
    private

    private

    def validate_date_format_and_presence
        if !self.InterviewDate.blank? && !self.InterviewDate.match?(/\A\d{4}-\d{2}-\d{2}\z/)
        errors.add(:InterviewDate, "phải có định dạng YYYY-MM-DD")
        elsif self.InterviewDate.blank?
        errors.add(:InterviewDate, "Chưa nhập date")
        end
    end

    def validate_each(record, attribute, value)
        return if self.InterviewDate.blank?
        self.InterviewDate.to_datetime rescue record.errors[attribute] << (options[:message] || "must be a date.")
      end
  end
  