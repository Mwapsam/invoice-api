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

ActiveRecord::Schema[7.0].define(version: 2023_10_29_054520) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
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

  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "audit_logs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "action"
    t.string "action_details"
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_audit_logs_on_user_id"
  end

  create_table "customers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email"
    t.string "merchant_customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "address1"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.string "country"
    t.string "phone_number"
    t.uuid "user_id", null: false
    t.string "stripe_customer_id"
    t.string "payment_method"
    t.index ["email"], name: "index_customers_on_email"
    t.index ["stripe_customer_id"], name: "index_customers_on_stripe_customer_id"
    t.index ["user_id"], name: "index_customers_on_user_id"
  end

  create_table "invoices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "description"
    t.date "due_date"
    t.boolean "send_immediately"
    t.boolean "allow_partial_payments"
    t.string "delivery_mode"
    t.uuid "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.index ["customer_id"], name: "index_invoices_on_customer_id"
  end

  create_table "line_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "product_sku"
    t.string "product_name"
    t.integer "quantity"
    t.decimal "unit_price"
    t.decimal "discount_amount"
    t.decimal "tax_amount"
    t.decimal "tax_rate"
    t.decimal "total_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "order_id"
  end

  create_table "orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.jsonb "amount_details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "payment_status", default: false
    t.uuid "user_id", null: false
    t.uuid "invoice_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "payments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "mode"
    t.string "paid_to"
    t.uuid "invoice_id", null: false
    t.uuid "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "transaction_id"
    t.integer "amount"
    t.string "currency"
    t.string "status"
    t.index ["customer_id"], name: "index_payments_on_customer_id"
    t.index ["invoice_id"], name: "index_payments_on_invoice_id"
  end

  create_table "people", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.date "birth_date"
    t.string "email"
    t.string "address_line_1"
    t.string "address_line_2"
    t.string "state"
    t.string "postal_code"
    t.string "city"
    t.string "place_of_birth"
    t.string "account_type"
    t.string "verification_method"
    t.string "passport_or_national_id"
    t.string "photo_id_front"
    t.string "photo_id_back"
    t.string "selfie_with_id"
    t.string "kyc_status", default: "Pending"
    t.text "kyc_status_note"
    t.datetime "status_update_date"
    t.date "identification_issue_date"
    t.date "identification_expiry"
    t.inet "kyc_submitted_ip_address"
    t.inet "registered_ip_address"
    t.boolean "us_citizen_tax_resident", default: false
    t.boolean "accept_terms", default: false
    t.boolean "agreed_to_data_usage", default: false
    t.string "citizenship"
    t.string "second_citizenship"
    t.string "country_residence"
    t.string "kyc_country"
    t.datetime "kyc_review_date"
    t.inet "reviewer_ip_address"
    t.string "kyc_refused_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_people_on_user_id"
  end

  create_table "token_validates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "token"
    t.boolean "is_valid", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "invoice_id", null: false
    t.index ["invoice_id"], name: "index_token_validates_on_invoice_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "phone_number"
    t.string "role", default: "client"
    t.string "password_digest"
    t.boolean "approved", default: false
    t.integer "account_balance", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stripe_customer_id"
    t.string "kyc_status", default: "pending"
    t.string "stripe_payment_id"
    t.index ["stripe_payment_id"], name: "index_users_on_stripe_payment_id", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "audit_logs", "users"
  add_foreign_key "customers", "users"
  add_foreign_key "line_items", "orders"
  add_foreign_key "orders", "invoices"
  add_foreign_key "orders", "users"
  add_foreign_key "payments", "customers"
  add_foreign_key "payments", "invoices"
  add_foreign_key "people", "users"
  add_foreign_key "token_validates", "invoices"
end
