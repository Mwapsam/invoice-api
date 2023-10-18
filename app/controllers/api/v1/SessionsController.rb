class Api::V1::SessionsController < ApplicationController
    def create
      user = User.find_by(phone_number: params[:phone_number])
  
      if user && user.authenticate(params[:password])
        token = issue_token(user)
        render json: { user: user, token: token }, status: :ok
      else
        render json: { error: 'Invalid phone number or password' }, status: :unauthorized
      end
    end
  
    def destroy
      render json: { message: 'Logged out successfully' }, status: :ok
    end
end