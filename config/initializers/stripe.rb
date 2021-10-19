Rails.configuration.stripe = {
  :publishable_key => ENV['STRIPE_PUBLISHABLE_KEY'],
  :secret_key => ENV['STRIPE_SECRET_KEY'],
  :price_key => ENV['STRIPE_PRICE_KEY'],
  :webhook_key => ENV['STRIPE_WEBHOOK_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
