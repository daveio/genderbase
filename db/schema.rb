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

ActiveRecord::Schema[8.1].define(version: 2026_02_14_172732) do
  create_table "answers", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.integer "question_id", null: false
    t.integer "responder_id", null: false
    t.datetime "updated_at", null: false
    t.index [ "question_id" ], name: "index_answers_on_question_id"
    t.index [ "responder_id" ], name: "index_answers_on_responder_id"
  end

  create_table "knowledges", force: :cascade do |t|
    t.text "body"
    t.integer "category"
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "question_id", null: false
    t.integer "responder_id", null: false
    t.string "slug"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index [ "question_id" ], name: "index_knowledges_on_question_id"
    t.index [ "responder_id" ], name: "index_knowledges_on_responder_id"
  end

  create_table "questions", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "pseudonym"
    t.integer "responder_id", null: false
    t.integer "status"
    t.string "title"
    t.string "token"
    t.datetime "updated_at", null: false
    t.index [ "responder_id" ], name: "index_questions_on_responder_id"
  end

  create_table "responders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.string "pseudonym"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index [ "email" ], name: "index_responders_on_email", unique: true
    t.index [ "pseudonym" ], name: "index_responders_on_pseudonym", unique: true
    t.index [ "reset_password_token" ], name: "index_responders_on_reset_password_token", unique: true
  end

  create_table "terminologies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "definition"
    t.text "info"
    t.integer "responder_id", null: false
    t.string "term"
    t.datetime "updated_at", null: false
    t.index [ "responder_id" ], name: "index_terminologies_on_responder_id"
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "responders"
  add_foreign_key "knowledges", "questions"
  add_foreign_key "knowledges", "responders"
  add_foreign_key "questions", "responders"
  add_foreign_key "terminologies", "responders"
end
