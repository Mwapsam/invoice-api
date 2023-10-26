class ApplicationController < ActionController::API
  include JwtHelper

  private

  def authenticate_user
    token = request.headers['Authorization']
    if token.present?
      user_id = user_id(token)
      if user_id
        @current_user = User.find(user_id)
      else
        render json: { error: 'Invalid token' }, status: :unauthorized
      end
    else
      render json: { error: 'Unauthorised request!' }, status: :unauthorized
    end
  end

  def log_audit_action(user, action, details)
    AuditLog.create(user:, action:, action_details: details)
  end
end
