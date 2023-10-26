class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user, only: %i[index signed_user]
  rescue_from AuthenticationError, with: :unauthorized

  def index
    users = User.includes(:customers)
    render json: { data: users, message: 'Success' }, status: :ok
  end

  def signed_user
    raise AuthenticationError, "You're not logged in!" unless @current_user.present?

    render json: { data: @current_user, message: 'Success' }, status: :ok
  end

  def create
    user = User.new(user_params)

    if user.save
      token = issue_token(user)
      render json: { user:, jwt: token, message: 'Congraturations, your account is successfully created. Check the code sent on WhatsApp to activate your account!' }, status: :created
    else
      render json: { errors: user.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  rescue StandardError
    render json: { error: 'User could not be created. Please check the provided data.' }, status: :internal_server_error
  end

  private

  def unauthorized(error)
    render json: { error: error.message }, status: :unauthorized
  end

  def user_params
    params.require(:user).permit(:phone_number, :password)
  end
end
