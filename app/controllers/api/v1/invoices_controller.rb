require 'whatsapp_service'

class Api::V1::InvoicesController < ApplicationController
  before_action :authenticate_user, except: :one_invoice

  # include CyberSourcePayment
  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10

    invoices = @current_user.invoices.includes(:customer, :order)
      .paginate(page:, per_page:)

    total_items = invoices.total_entries
    total_pages = (total_items.to_f / per_page.to_i).ceil

    response.headers['X-Total-Pages'] = total_pages.to_s

    render json: invoices, include: %i[customer order line_items], status: :ok
  end

  def load_invoices
    total_items = params[:total_item].to_i
    invoices = @current_user.invoices.includes(:customer, :order).limit(total_items)
    render json: invoices, include: %i[customer order line_items], status: :ok
  end

  def show
    invoice = Invoice.find(params[:id])
    render json: invoice, include: %i[customer order line_items], status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Invoice not found' }, status: :not_found
  end

  def one_invoice
    invoice = Invoice.find(params[:id])
    token = TokenValidate.find_by(token: params[:token])
    if token.is_valid
      render json: invoice, include: %i[customer order line_items], status: :ok
    else
      render json: { error: 'Invalid link!' }, status: :not_found
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Invoice not found' }, status: :not_found
  end

  def create
    random_number = SecureRandom.random_number(10_000)
    digit = format('%04d', random_number)

    amount_details = {
      invoice_identifier: "INV#{digit}",
      product_name: params[:product_name],
      total_amount: params[:total_amount],
      currency: params[:currency],
      discount_amount: params[:discount_amount],
      discount_percent: params[:discount_percent],
      sub_amount: params[:sub_amount],
      minimum_partial_amount: params[:minimum_partial_amount],
      tax_details: {
        type: 'State Tax',
        amount: params[:amount],
        rate: params[:rate]
      },
      quantity: params[:quantity]
    }

    ActiveRecord::Base.transaction do
      invoice = @current_user.invoices.new(
        description: params[:description],
        due_date: params[:due_date],
        send_immediately: false,
        allow_partial_payments: false,
        delivery_mode: 'Online',
        customer_id: params[:customer_id]
      )

      if invoice.save
        order = invoice.build_order(amount_details:, user_id: @current_user.id)
        if order.save
          line_items = JSON.parse(params[:line_items])
          create_line_items_for_invoice(invoice, line_items)
          # process_payment(order, amount_details)
        else
          render json: { error: order.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
        log_audit_action(@current_user, 'Invoice created', "Invoice ID: #{invoice.id}")
        render json: invoice, status: :created
      else
        render json: { error: invoice.errors.full_messages.join(', ') }, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    end
  end

  def send_invoice
    invoice = Invoice.find_by(id: params[:invoice_id])
    api_token = Rails.application.credentials.whatsapp[:token]
    token_validate = invoice.token_validates.create(token: SecureRandom.uuid, is_valid: true)
    to_phone_number = invoice.customer.phone_number
    whatsapp_service = WhatsappService.new(api_token)
    ui_host = 'http://127.0.0.1:5173'

    if token_validate.save
      invoice_url = "#{ui_host}/invoice-rendered/#{invoice.id}?token=#{token_validate.token}"
      message_body = "We are writing to inform you that
      #{invoice.customer.first_name} #{invoice.customer.last_name}
      has sent you an invoice. Follow the link below to view it:\n#{invoice_url}"

      InvoiceMailer.send_invoice(invoice, message_body).deliver_now

      result = whatsapp_service.send_message(to_phone_number, message_body)

      if result[:success]
        log_audit_action(@current_user, 'Invoice sent', "Invoice ID: #{invoice.id}")
        render json: { message: result[:message] }, status: :ok
      else
        render json: { error: result[:error] }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Token validation failed' }, status: :unprocessable_entity
    end
  end

  private

  def create_line_items_for_invoice(invoice, line_items)
    random_number = SecureRandom.random_number(10_000)
    digit = format('%04d', random_number)

    line_items.each do |line_item_params|
      invoice.order.line_items.create(
        product_sku: "INV#{digit}",
        product_name: line_item_params['product_name'],
        quantity: line_item_params['quantity'].to_i,
        unit_price: line_item_params['unit_price'].to_f,
        discount_amount: line_item_params['discount_amount'].to_f,
        tax_amount: line_item_params['tax_amount'].to_f,
        tax_rate: line_item_params['tax_rate'].to_f,
        total_amount: line_item_params['total_amount'].to_f
      )
    end
  end
end
