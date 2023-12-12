class CreateStudents < ActiveRecord::Migration[7.1]
  def change
    create_table :students, if_not_exists: true do |t|
      t.string :StudentCode
      t.string :StudentName
      t.string :ClassName
      t.string :PhoneNumber
      t.string :Email
      t.integer :AccountCode
      t.boolean :isVolunteerStudent

      t.timestamps
    end
  end
end
