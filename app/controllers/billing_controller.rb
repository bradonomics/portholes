class BillingController < ApplicationController

  def create
    if current_user.stripe_id
      @session = Stripe::Checkout::Session.create({
        customer: current_user.stripe_id,
        success_url: edit_user_registration_url,
        cancel_url: edit_user_registration_url,
        payment_method_types: ['card'],
        line_items: [
          { price: Rails.configuration.stripe[:price_key], quantity: 1 }
        ],
        mode: 'subscription',
        })
    else
      @session = Stripe::Checkout::Session.create({
        customer_email: current_user.email,
        success_url: edit_user_registration_url,
        cancel_url: edit_user_registration_url,
        payment_method_types: ['card'],
        line_items: [
          { price: Rails.configuration.stripe[:price_key], quantity: 1 }
        ],
        mode: 'subscription',
        })
    end
    respond_to :js
  end

  def edit
    @session = Stripe::BillingPortal::Session.create({
      customer: current_user.stripe_id,
      return_url: edit_user_registration_url,
    })
    redirect_to @session.url
  end

end
