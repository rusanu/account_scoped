module AccountScoped
  module ActiveSupportConcern 
    extend ActiveSupport::Concern

    def with_account(account)
      old_account = AccountScoped.current_account
      begin
        AccountScoped.current_account = account
        yield
      ensure
        AccountScoped.current_account = old_account
      end
    end
  end
end
