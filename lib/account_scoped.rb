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
  end
  
  def self.setup(&block)
    yield self
  end
end

