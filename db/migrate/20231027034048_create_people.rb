class CreatePeople < ActiveRecord::Migration[7.0]
  def change
    create_table :people, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :first_name
      t.string :last_name
      t.date :birth_date
      t.string :email
      t.string :address_line_1
      t.string :address_line_2
      t.string :state
      t.string :postal_code
      t.string :city
      t.string :place_of_birth
      t.string :account_type
      t.string :verification_method
      t.string :passport_or_national_id
      t.string :photo_id_front
      t.string :photo_id_back
      t.string :selfie_with_id
      t.string :kyc_status, default: 'Pending'
      t.text :kyc_status_note
      t.datetime :status_update_date
      t.date :identification_issue_date
      t.date :identification_expiry
      t.inet :kyc_submitted_ip_address
      t.inet :registered_ip_address
      t.boolean :us_citizen_tax_resident, default: false
      t.boolean :accept_terms, default: false
      t.boolean :agreed_to_data_usage, default: false
      t.string :citizenship
      t.string :second_citizenship
      t.string :country_residence
      t.string :kyc_country
      t.datetime :kyc_review_date
      t.inet :reviewer_ip_address
      t.string :kyc_refused_code

      t.timestamps
    end
  end
end
