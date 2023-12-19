class Interview < ApplicationRecord
    self.table_name = 'interview'
    validates :InterviewDate, presence: { message: "Custom message for InterviewDate" }
    validates :InterviewRoom, presence: { message: "Custom message for InterviewRoom" }
    validates :Quantity, presence: { message: "Custom message for Quantity" }
    validates :QuantityMax, presence: { message: "Custom message for QuantityMax" }
end
