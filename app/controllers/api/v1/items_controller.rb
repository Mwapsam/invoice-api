class Api::V1::ItemsController < ApplicationController
  before_action :authenticate_user

  def index
    items = @current_user.line_items.includes(:order)
    render json: items, include: :order, status: :ok
  end
end
