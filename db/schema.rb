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

ActiveRecord::Schema[7.2].define(version: 2024_10_23_022145) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "breeds", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dog_traits", force: :cascade do |t|
    t.integer "dog_id", null: false
    t.integer "trait_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dog_id"], name: "index_dog_traits_on_dog_id"
    t.index ["trait_id"], name: "index_dog_traits_on_trait_id"
  end

  create_table "dogs", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.text "description"
    t.integer "sub_breed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "breed_id"
    t.string "image_url"
    t.index ["sub_breed_id"], name: "index_dogs_on_sub_breed_id"
  end

  create_table "images", force: :cascade do |t|
    t.string "url"
    t.integer "breed_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["breed_id"], name: "index_images_on_breed_id"
  end

  create_table "sub_breeds", force: :cascade do |t|
    t.string "name"
    t.integer "breed_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.index ["breed_id"], name: "index_sub_breeds_on_breed_id"
  end

  create_table "traits", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "dog_traits", "dogs"
  add_foreign_key "dog_traits", "traits"
  add_foreign_key "dogs", "sub_breeds"
  add_foreign_key "images", "breeds"
  add_foreign_key "sub_breeds", "breeds"
end
