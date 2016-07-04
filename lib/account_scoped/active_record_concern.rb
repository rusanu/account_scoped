module AccountScoped
  module ActiveRecordConcern
    extend ActiveSupport::Concern

    module ClassMethods
      def account_scope_cache
        AccountScoped.account_scope_cache
      end

      def account_scoped
        belongs_to :account, optional: true

        default_scope lambda {
          arel = AccountScoped.current_account.nil? ? 
            self.all : self.where({:account_id => AccountScoped.current_account.id})
          return arel
        }

        scope :account_scope, lambda {
          where({:account_id => AccountScoped.current_account.id})
        }
        
        before_create Proc.new {|m|
          m.account =  AccountScoped.current_account unless AccountScoped.current_account.nil?
        }

      end
    end
  end
end
