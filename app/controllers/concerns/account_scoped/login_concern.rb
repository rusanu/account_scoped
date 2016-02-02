module AccountScoped
  module LoginConcern
    extend ActiveSupport::Concern

    def is_user_logged_in?
      return !session[:user_id].nil? &&
          !session[:account_id].nil?
    end

    def login_user(user, account = nil)
      account ||= user.default_account
      session[:user_id] = user.id
      session[:account_id] = account.id
    end

    def logout_user
      session[:user_id] = nil
      session[:account_id] = nil
    end

    def current_user
      ensure_user_logged_in
      User.find session[:user_id]
    end

    def current_account
      ensure_user_logged_in
      Account.find session[:account_id]
    end

    def current_account_id
      ensure_user_logged_in
      session[:account_id]
    end

    def ensure_user_logged_in
      raise AuthorizationConcern::UserRequired if !is_user_logged_in?
    end

    included do
      helper_method :is_user_logged_in?, :current_user, :current_account
    end

  end
end
