
class Interview < ApplicationRecord
    self.table_name = 'interview'
    validate do |interview|
        interview.errors.add(:base, "Trường số lượng không được để trống!") if interview.QuantityMax.blank?
        interview.errors.add(:base, "Số lượng phải lớn hơn 0") unless interview.QuantityMax.to_i > 0
        interview.errors.add(:base, "Trường ngày phỏng vấn không được để trống!") if interview.InterviewDate.blank?
        interview.errors.add(:base, "Định dạng ngày phỏng vấn không hợp lệ") unless interview.InterviewDate.is_a?(Date)
        interview.errors.add(:base, "Trường phòng phỏng vấn không được để trống!") if interview.InterviewRoom.blank?
      end

  end
  