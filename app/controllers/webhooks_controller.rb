class WebhooksController < ApplicationController
  before_action :authenticate_user!, except: [:create]
  skip_before_action :verify_authenticity_token

  def create
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, Rails.configuration.stripe[:webhook_key]
      )
    rescue JSON::ParserError => error
      # Invalid payload
      puts "⚠️  Webhook error while parsing basic request. #{error.message})"
      status 400
      return
    rescue Stripe::SignatureVerificationError => error
      # Invalid signature
      puts "Signature error"
      puts error
      return
    end

    # Handle the event
    case event.type
    when 'customer.created'
      user = User.find_by(email: event.data.object.email)
      user.update(stripe_id: event.data.object.id)
    when 'customer.subscription.created', 'customer.subscription.updated', 'customer.subscription.deleted'
      user = User.find_by(stripe_id: event.data.object.customer)
      if event.data.object.status == 'paid' || event.data.object.status == 'active'
        user.update(subscriber: true)
      else
        user.update(subscriber: false)
      end
    end
    status 200

    render json: { message: 'success' }
  end

end
