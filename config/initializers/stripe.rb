if Rails.env.production?
    Stripe.api_key = Rails.application.credentials.stripe[:secret_live]
    Stripe.client_id = Rails.application.credentials.stripe[:public]
else
    Stripe.api_key = Rails.application.credentials.stripe[:secret]
    Stripe.client_id = Rails.application.credentials.stripe[:public]
end
  