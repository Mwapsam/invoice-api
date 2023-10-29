class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user, only: %i[index signed_user debit_card list_payment_methods]
  rescue_from AuthenticationError, with: :unauthorized

  def index
    users = User.includes(:customers)
    render json: { data: users, message: 'Success' }, status: :ok
  end

  def signed_user
    raise AuthenticationError, "You're not logged in!" unless @current_user.present?

    render json: { data: @current_user, message: 'Success' }, status: :ok
  end

  def list_payment_methods
    payment_methods_data = @current_user.customer_payment_methods

    if payment_methods_data

      render json: payment_methods_data, status: :ok
    else
      render json: { error: 'Failed to retrieve payment methods' }, status: :internal_server_error
    end
  end

  def create
    user = User.new(user_params)

    if user.save
      token = issue_token(user)
      render json: { user:, jwt: token, message: 'Congraturations, your account is successfully created. Check the code sent on WhatsApp to activate your account!' },
             status: :created
    else
      render json: { errors: user.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  rescue StandardError
    render json: { error: 'User could not be created. Please check the provided data.' }, status: :internal_server_error
  end

  def debit_card
    payment_method_id = params[:payment_method_id]
    result = @current_user.create_payment_method(payment_method_id)

    if result[:success]
      render json: { message: result[:message] }, status: :ok
    else
      render json: { error: result[:error] }, status: :unprocessable_entity
    end
  end

  private

  def unauthorized(error)
    render json: { error: error.message }, status: :unauthorized
  end

  def user_params
    params.require(:user).permit(:phone_number, :password)
  end
end
