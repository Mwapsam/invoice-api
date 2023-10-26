if Rails.env.production?
    Stripe.api_key = Rails.application.credentials.stripe[:secret_live]
else
    Stripe.api_key = Rails.application.credentials.stripe[:secret]
end
  