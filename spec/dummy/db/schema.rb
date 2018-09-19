# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171128170851) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "patients", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.date     "date_of_birth"
    t.integer  "provider_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "patients", ["provider_id"], name: "index_patients_on_provider_id", using: :btree

  create_table "providers", force: :cascade do |t|
    t.string   "npi"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "visits", force: :cascade do |t|
    t.date     "visit_date"
    t.boolean  "uds_universe"
    t.integer  "patient_id"
    t.integer  "provider_id"
    t.integer  "visit_type_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "visits", ["patient_id"], name: "index_visits_on_patient_id", using: :btree
  add_index "visits", ["provider_id"], name: "index_visits_on_provider_id", using: :btree
  add_index "visits", ["visit_type_id"], name: "index_visits_on_visit_type_id", using: :btree

end
