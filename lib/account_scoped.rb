require "account_scoped/version"
require "account_scoped/active_record_concern"
require "account_scoped/action_controller_concern"
require "account_scoped/active_support_concern"
require "account_scoped/engine"

module AccountScoped

  class << self
    mattr_accessor :login_path

    def current_account
      Thread.current[:AccountScoped]
    end

    def current_account=(account)
      Thread.current[:AccountScoped] = account
    end

    def account_scope_cache
      self.current_account ? {:namespace => "account:#{self.current_account.id}"} : {}
    end

    def login_user(session, user, account = nil)
      account ||= user.default_account
      session[:user_id] = user.id
      session[:account_id] = account.id
      current_account = account
    end
    
    def logout_user(session)
      session.delete :user_id
      session.delete :account_id
      current_account = nil
    end

    def is_logged_in?(session)
      session.has_key?(:user_id) && session.has_key?(:account_id)
    end

  end
  
  def self.setup(&block)
    yield self
  end
end

