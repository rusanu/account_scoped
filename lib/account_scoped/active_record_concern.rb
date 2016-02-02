module AccountScoped
  module ActiveRecordConcern
    extend ActiveSupport::Concern

    module ClassMethods
      def account_scope_cache
        AccountScoped.account_scope_cache
      end

      def account_scoped
        belongs_to :account

        default_scope lambda {
          where ({:account_id => AccountScoped.current_account.id}) \
            unless AccountScoped.current_account.nil?
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
