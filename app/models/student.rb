class Student < ApplicationRecord
    self.table_name = 'student'
  
  validates :StudentCode, :StudentName, :ClassName, :PhoneNumber, :Email, presence: { message: "không được để trống" }
  validates :StudentCode, uniqueness: { message: "đã tồn tại trong hệ thống" }
  validates :PhoneNumber, length: { maximum: 11, message: "không vượt quá %{count} ký tự" },  numericality: { only_integer: true, message: "phải là số" }
  validates :Email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "không hợp lệ" }
  validates :isVolunteerStudent, inclusion: { in: [true, false], message: "phải là true hoặc false" }
end
