class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by(phone_number: params[:phone_number])

    if user&.authenticate(params[:password])
      token = issue_token(user)
      render json: { user:, token: }, status: :ok
    else
      render json: { error: 'Invalid phone number or password' }, status: :unauthorized
    end
  end

  def single_session
    customer = Customer.find_by(id: params[:customer_id])
  
    if customer.nil?
      render json: { error: 'Customer not found' }, status: :not_found
      return
    end
  
    user = User.find_by(phone_number: customer.phone_number)
  
    if user&.authenticate(params[:password])
      token = issue_token(user)
      render json: { user: user, jwt: token, message: 'User logged in successfully' }, status: :ok
    else
      user = User.new(phone_number: customer.phone_number, password: params[:password])
  
      if user.save
        token = issue_token(user)
        render json: { user: user, jwt: token, message: 'User created and logged in successfully' }, status: :created
      else
        render json: { errors: user.errors.full_messages, message: 'Validation failed' }, status: :unprocessable_entity
      end
    end
  
  rescue StandardError => e
    Rails.logger.error("An error occurred: #{e.message}")
    render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
  end
  
  

  def destroy
    render json: { message: 'Logged out successfully' }, status: :ok
  end
end
