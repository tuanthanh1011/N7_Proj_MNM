# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_12_24_092258) do
  create_table "activity", primary_key: "ActivityCode", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "ActivityName", null: false
    t.date "BeginingDate", null: false
    t.string "Manager", null: false
    t.float "SupportMoney", limit: 53, null: false
    t.text "Description", null: false
    t.date "CreatedAt"
    t.date "UpdatedAt"
  end

  create_table "interview", primary_key: "InterviewCode", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.date "InterviewDate", null: false
    t.string "InterviewRoom", null: false
    t.integer "Quantity", default: 0, null: false
    t.integer "QuantityMax", null: false
    t.date "CreatedAt"
    t.date "UpdatedAt"
    t.date "DeletedAt"
  end

  create_table "rating", primary_key: "RatingCode", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "RatingStar", null: false
    t.text "Description", null: false
    t.date "CreatedAt"
    t.date "UpdatedAt"
  end

  create_table "student", primary_key: "StudentCode", id: { type: :string, limit: 50 }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "StudentName", null: false
    t.string "ClassName", null: false
    t.string "PhoneNumber", null: false
    t.string "Email", null: false
    t.integer "AccountCode"
    t.boolean "isVolunteerStudent", default: false, null: false
    t.date "CreatedAt"
    t.date "UpdatedAt"
    t.index ["AccountCode"], name: "Student_Account"
  end

  create_table "student_activity", id: false, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "ActivityCode", null: false
    t.string "StudentCode", limit: 50, null: false
    t.integer "RatingCode"
    t.index ["ActivityCode"], name: "Student_Activity"
    t.index ["RatingCode"], name: "Student_Rating"
    t.index ["StudentCode"], name: "Student"
  end

  create_table "student_interview", id: false, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "StudentCode", limit: 50, null: false
    t.integer "InterviewCode", null: false
    t.boolean "ResultInterview"
    t.date "CreatedAt"
    t.date "UpdatedAt"
    t.index ["InterviewCode"], name: "Student_Interview"
    t.index ["StudentCode"], name: "Student_Student_Interview"
  end

  create_table "volunteer_account", primary_key: "AccountCode", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "Username", null: false
    t.string "Password", null: false
    t.boolean "Role"
    t.date "CreatedAt"
    t.date "UpdatedAt"
  end

  add_foreign_key "student", "volunteer_account", column: "AccountCode", primary_key: "AccountCode", name: "Student_Account"
  add_foreign_key "student_activity", "activity", column: "ActivityCode", primary_key: "ActivityCode", name: "Student_Activity"
  add_foreign_key "student_activity", "rating", column: "RatingCode", primary_key: "RatingCode", name: "Student_Rating"
  add_foreign_key "student_activity", "student", column: "StudentCode", primary_key: "StudentCode", name: "Student"
  add_foreign_key "student_interview", "interview", column: "InterviewCode", primary_key: "InterviewCode", name: "Student_Interview"
  add_foreign_key "student_interview", "student", column: "StudentCode", primary_key: "StudentCode", name: "Student_Student_Interview"
end
