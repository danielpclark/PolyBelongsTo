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

ActiveRecord::Schema.define(version: 20150511161648) do

  create_table "addresses", force: :cascade do |t|
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id"

  create_table "alphas", force: :cascade do |t|
    t.string   "content"
    t.integer  "delta_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "alphas", ["delta_id"], name: "index_alphas_on_delta_id"

  create_table "beta", force: :cascade do |t|
    t.string   "content"
    t.integer  "alpha_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "beta", ["alpha_id"], name: "index_beta_on_alpha_id"

  create_table "capas", force: :cascade do |t|
    t.string   "content"
    t.integer  "beta_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "capas", ["beta_id"], name: "index_capas_on_beta_id"

  create_table "cars", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cars", ["user_id"], name: "index_cars_on_user_id"

  create_table "coffees", force: :cascade do |t|
    t.integer  "coffeeable_id"
    t.string   "coffeeable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "coffees", ["coffeeable_type", "coffeeable_id"], name: "index_coffees_on_coffeeable_type_and_coffeeable_id"

  create_table "contacts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["user_id"], name: "index_contacts_on_user_id"

  create_table "delta", force: :cascade do |t|
    t.string   "content"
    t.integer  "capa_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delta", ["capa_id"], name: "index_delta_on_capa_id"

  create_table "geo_locations", force: :cascade do |t|
    t.integer  "address_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "geo_locations", ["address_id"], name: "index_geo_locations_on_address_id"

  create_table "phones", force: :cascade do |t|
    t.integer  "phoneable_id"
    t.string   "phoneable_type"
    t.string   "content"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "phones", ["phoneable_type", "phoneable_id"], name: "index_phones_on_phoneable_type_and_phoneable_id"

  create_table "photos", force: :cascade do |t|
    t.integer  "photoable_id"
    t.string   "photoable_type"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "photos", ["photoable_type", "photoable_id"], name: "index_photos_on_photoable_type_and_photoable_id"

  create_table "profiles", force: :cascade do |t|
    t.integer  "profileable_id"
    t.string   "profileable_type"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profiles", ["profileable_type", "profileable_id"], name: "index_profiles_on_profileable_type_and_profileable_id"

  create_table "squishies", force: :cascade do |t|
    t.string   "content"
    t.integer  "squishable_id"
    t.string   "squishable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "squishies", ["squishable_type", "squishable_id"], name: "index_squishies_on_squishable_type_and_squishable_id"

  create_table "ssns", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ssns", ["user_id"], name: "index_ssns_on_user_id"

  create_table "tags", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tags", ["user_id"], name: "index_tags_on_user_id"

  create_table "tires", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "car_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tires", ["car_id"], name: "index_tires_on_car_id"
  add_index "tires", ["user_id"], name: "index_tires_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
