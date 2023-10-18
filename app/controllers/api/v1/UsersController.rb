class Api::V1::UsersController < ApplicationController
    before_action :authenticate_user, only: [:index, :signed_user]

    def index
        users = User.includes(:customers)
        render json: users, status: 201
    end

    def signed_user
      render json: @current_user, status: 201
    end

    def create
        user = User.new(user_params)
    
        if user.save
          token = issue_token(user)
          render json: { user: user, jwt: token}, status: :created
    
        elsif user.errors.messages
          render json: user.errors.full_messages.to_sentence, status: :unprocessable_entity
        else
          render json: { error: 'User could not be created.' }, status: :internal_server_error
        end
    end
    
    private

    def user_params
        params.require(:user).permit(:phone_number, :password)
    end
end