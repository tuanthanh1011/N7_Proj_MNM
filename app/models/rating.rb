class Rating < ApplicationRecord
    self.table_name = 'rating'
    has_one :student_activity, foreign_key: 'RatingCode', primary_key: 'RatingCode'

    validate do |rating|
        rating.errors.add(:base, "Trường điểm đánh giá không được để trống!") if rating.RatingStar.blank?
        rating.errors.add(:base, "Trường nội dung đánh giá không được để trống!") if rating.Description.blank?

        if rating.RatingStar.present? && rating.Description.present?
            rating.errors.add(:base, "Trường điểm đánh giá phải là số có giá trị từ 1 - 5!") unless rating.RatingStar.between?(1, 5)
        end
    end

end
