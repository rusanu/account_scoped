module AccountScoped
  class Engine < ::Rails::Engine

  initializer :account_scoped_active_record_concern do |app|
    ActiveRecord::Base.send(:include,
      AccountScoped::ActiveRecordConcern)
  end

  initializer :account_scoped_active_controller_concern do |app|
    ActionController::Base.send(:include,
      AccountScoped::ActionControllerConcern)
  end

  initializer :account_scoped_active_suport_concern do |app|
    ActiveSupport::TestCase.send(:include,
      AccountScoped::ActiveSupportConcern)
  end

  end
end
