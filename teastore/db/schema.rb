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

ActiveRecord::Schema.define(version: 20180123144058) do

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.decimal "total_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "client_id"
    t.index ["client_id"], name: "index_orders_on_client_id"
  end

  create_table "teas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "price"
    t.boolean "is_menu"
    t.integer "order_id"
    t.integer "ordered_quantity"
    t.string "type"
    t.string "name"
    t.string "made_in"
    t.boolean "drink_with_milk"
    t.integer "steeping_time"
    t.integer "stock_quantity"
    t.index ["order_id"], name: "index_teas_on_order_id"
  end

end
