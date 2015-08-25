require "account_scoped/version"

module AccountScoped

  def self.current_account
    Thread.current[:AccountScoped]    
  end

  def self.current_account=(account)
    Thread.current[:AccountScoped] = account
  end

  def self.account_scope_cache
    self.current_account ? {:namespace => "account:#{self.current_account.id}"} : {}
  end

  module ModelExtensions
    extend ActiveSupport::Concern

    module ClassMethods
      def account_scope_cache
        AccountScoped.account_scope_cache
      end

      def account_scoped
        belongs_to :account

        default_scope lambda {
          where ({:account_id => AccountScoped.current_account.id}) \
            if AccountScoped.current_account
        }

        scope :account_scope, lambda {
          where({:account_id => AccountScoped.current_account.id})
        }
        
        before_create Proc.new {|m|
          m.account =  AccountScoped.current_account if AccountScoped.current_account
        }

      end
    end # ClassMethods

  end # ModelExtensions

  module ControllerExtensions
      def account_scope_cache
        AccountScoped.account_scope_cache
      end

      def account_scoped
        self.class_eval do

          before_filter :validate_account_scope

          private

            def validate_account_scope
              begin
                if session[:account_id].present?
                  AccountScoped.current_account = Account.find(session[:account_id])
                else
                  redirect_to login_path
                end
              rescue
                  redirect_to login_path
              end
            end
         end  
      end 

  end # ControllerExtensions

  module TestCaseExtensions
    def with_account(account)
      old_account = AccountScoped.current_account
      begin
        AccountScoped.current_account = account
        yield
      ensure
        AccountScoped.current_account = old_account
      end
    end
  end # TestCaseExtensions

end # AccountScoped

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.send(:include, AccountScoped::ModelExtensions)
  ActionController::Base.extend AccountScoped::ControllerExtensions
end

if defined?(ActiveSupport::TestCase)
  ActiveSupport::TestCase.send(:include, AccountScoped::TestCaseExtensions)
end

