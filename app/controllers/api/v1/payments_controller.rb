require 'json'

class Api::V1::PaymentsController < ApplicationController
  include CyberSourcePayment
  include CurrencyConverter 

  def create
    invoice = Invoice.find_by(id: params[:invoice_id])
  
    ActiveRecord::Base.transaction do
      total_amount = invoice.order.amount_details['total_amount']
      currency = invoice.order.amount_details['currency']
  
      transfer_group = "order#{invoice.id}to#{invoice.customer.id}on#{Time.current}"
  
      # Create a PaymentIntent and confirm it
      payment_intent_params = {
        payment_method: params[:payment_method],
        amount: total_amount,
        currency: currency,
        confirm: true,
        payment_method_types: ['card'],
        customer: invoice.customer.stripe_customer_id,
        transfer_group: transfer_group,
        setup_future_usage: 'off_session'
      }
  
      payment_intent = Stripe::PaymentIntent.create(payment_intent_params)
  
      if payment_intent[:status] != 'succeeded'
        render json: { error: 'Payment invalid' }, status: :bad_request
      end
  
      payment_id = payment_intent['id']
      authorized_amount = payment_intent['amount']
      payment_status = payment_intent['status']
      currency = payment_intent['currency']
  
      # Create a Payment record
      payment = Payment.create(
        mode: params[:mode],
        customer_id: invoice.customer.id,
        invoice_id: invoice.id,
        paid_to: invoice.customer.email,
        amount: authorized_amount.to_i,
        transaction_id: payment_id,
        status: payment_status,
        currency: currency,
      )
  
      if payment.save
        # Save the payment method for future use
        payment_method_id = params[:payment_method]
        payment.handle_payment_method(payment_method_id)
  
        user = invoice.customer.user
        user.update_balance(total_amount.to_i, currency)
  
        render json: payment, status: :created
      else
        render json: { error: payment.errors.full_messages.join(', ') }, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Invoice not found' }, status: :not_found
  end
  

  def send_money
    charge = Stripe::Charge.create({
      amount: 1000,               
      currency: 'usd',            
      payment_method: 'pm_your_payment_method_id',  
      description: 'Payment for services',
    })
  end
end
