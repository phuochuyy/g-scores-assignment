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

ActiveRecord::Schema[8.0].define(version: 2025_10_23_023510) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "students", force: :cascade do |t|
    t.string "sbd", null: false
    t.decimal "toan", precision: 3, scale: 2
    t.decimal "ngu_van", precision: 3, scale: 2
    t.decimal "ngoai_ngu", precision: 3, scale: 2
    t.decimal "vat_li", precision: 3, scale: 2
    t.decimal "hoa_hoc", precision: 3, scale: 2
    t.decimal "sinh_hoc", precision: 3, scale: 2
    t.decimal "lich_su", precision: 3, scale: 2
    t.decimal "dia_li", precision: 3, scale: 2
    t.decimal "gdcd", precision: 3, scale: 2
    t.string "ma_ngoai_ngu"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sbd"], name: "index_students_on_sbd", unique: true
  end
end
