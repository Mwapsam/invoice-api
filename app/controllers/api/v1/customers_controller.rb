class Api::V1::CustomersController < ApplicationController
  before_action :authenticate_user

  def index
    customers = Customer.includes(:invoices)
    render json: customers, include: :invoices, status: :ok
  end

  def create
    customer_params = params.require(:customer).permit(
      :email,
      :first_name,
      :last_name,
      :address1,
      :city,
      :state,
      :postal_code,
      :country,
      :phone_number
    )

    customer = @current_user.customers.new(customer_params)

    if customer.save
      log_audit_action(@current_user, 'Customer added', "Customer ID: #{customer.id}")
      render json: customer, status: :created
    else
      render json: { error: customer.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end
end
