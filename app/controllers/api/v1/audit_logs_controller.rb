class Api::V1::AuditLogsController < ApplicationController
    before_action :authenticate_user
  
    def index
      @audit_logs = @current_user.audit_logs.includes(:user).order(created_at: :desc).limit(10)
      render json: @audit_logs, include: :user, status: :ok
    end
end
  