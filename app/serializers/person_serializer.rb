class PersonSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id,
             :first_name,
             :last_name,
             :birth_date,
             :email,
             :address_line_1,
             :address_line_2,
             :state,
             :postal_code,
             :city,
             :place_of_birth,
             :account_type,
             :verification_method,
             :passport_or_national_id,
             :photo_id_front,
             :photo_id_back,
             :selfie_with_id,
             :kyc_status,
             :kyc_status_note,
             :status_update_date,
             :identification_issue_date,
             :identification_expiry,
             :kyc_submitted_ip_address,
             :registered_ip_address,
             :us_citizen_tax_resident,
             :accept_terms,
             :agreed_to_data_usage,
             :citizenship,
             :second_citizenship,
             :country_residence,
             :kyc_country,
             :kyc_review_date,
             :reviewer_ip_address,
             :kyc_refused_code,
             :card_back,
             :card_front

  def card_front
    rails_blob_path(object.card_front, only_path: true) if object.card_front.attached?
  end

  def card_back
    rails_blob_path(object.card_back, only_path: true) if object.card_back.attached?
  end
end
