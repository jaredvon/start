class ApplicationController < ActionController::Base
	before_action :load_schema,:authenticate_user!,:set_email_host
	
	private 
	def load_schema
		Apartment::Tenant.switch!('public')
		return unless request.subdomain.present?

		Apartment::Tenant.switch!(request.subdomain)
	end

	def current_account
		@current_account ||= Account.find_by(subdomain: request.subdomain)
	end

	def set_email_host
		subdomain = current_account ? "{current_account.subdomain}." : ""
		ActionMailer::Base.default_url_options[:host] = "#{}"
	end
end
