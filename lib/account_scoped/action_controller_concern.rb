module AccountScoped
  module ActionControllerConcern
    extend ActiveSupport::Concern

    def account_scope_cache
      AccountScoped.account_scope_cache
    end

    module ClassMethods

      def account_scoped
        self.class_eval do

          before_filter :validate_account_scope

          private

            def validate_account_scope
              if session[:account_id].present?
                begin
                  AccountScoped.current_account = Account.find(session[:account_id])
                rescue Exception => e
                  Rails.logger.error "validate_account_scope account_id: #{session[:account_id]} ex:#{e.to_s}"
                  redirect_to_login_path
                end
              else
                redirect_to_login_path
              end
            end

            def redirect_to_login_path
              Rails.logger.debug "validate_account_scope redirect to login_path: #{session[:account_id]} xhr?:#{request.xhr?}"
              if request.xhr?
                render nothing: true, status: :forbidden
              else
                redirect_to AccountScoped.login_path
              end
            end
         end  
      end 

      def check_account_scoped
          self.class_eval do
            before_filter :check_account_scope

            private 
            def check_account_scope
              begin
                AccountScoped.current_account = nil
                if session[:account_id].present?
                  AccountScoped.current_account = Account.find(session[:account_id])
                end
              rescue Exception => e
                  Rails.logger.debug "check_account_scope: account_id: #{session[:account_id]} exception: #{e.to_s}"
              end
            end
          end
      end
    end
  end
end
