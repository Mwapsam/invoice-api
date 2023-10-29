class Api::V1::PeopleController < ApplicationController
  before_action :authenticate_user
  rescue_from AuthenticationError, with: :unauthorized

  def index
    people = Person.includes(:user)
    render json: people, status: :ok
  end

  def create
    user = User.find_by(id: person_params['user_id'])

    if user.person.nil?
      person = Person.new(person_params)
    else
      person = user.person
      person.assign_attributes(person_params)
    end

    person.front_card.attach(person_params['front_card']) if person_params['front_card']
    person.back_card.attach(person_params['back_card']) if person_params['back_card']

    if person.save
      render json: { person:, message: 'Your profile is successfully submitted' }, status: :created
    else
      render json: { errors: person.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  rescue StandardError
    render json: { error: 'Profile could not be created. Please check the provided data.' }, status: :internal_server_error
  end

  private

  def unauthorized(error)
    render json: { error: error.message }, status: :unauthorized
  end

  def person_params
    params.require(:person).permit(
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
      :kyc_country,
      :user_id,
      :card_front,
      :card_back
      # :phone,
      # :gender,
    )
  end
end
