class ApplicationController < ActionController::Base

  add_flash_types :success, :warning, :error

  private

    def require_signin
      unless current_user
        session[:intended_url] = request.url
        redirect_to signin_path, error: "You must sign in to continue."
      end
    end

    def require_admin
      redirect_to root_url, error: "Unauthorized access." unless current_user_admin?
    end

    def current_user_admin?
      current_user && current_user.admin?
    end

    helper_method :current_user_admin?

end
