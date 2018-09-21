require 'rails_helper'

RSpec.feature "AccountCreations", type: :feature do

  describe "account creation" do
  		before do
  			@subdomain = "hello" + rand(10).to_s
  			sign_up(@subdomain)
  		end

  		it "allows user to create account" do
  			expect(page.current_url).to include(@subdomain)
  			Apartment::Tenant.switch!('public')
  			expect(Account.all.count).to eq(1)
  		end

  		it "allows access of subdomain" do
  			visit subdomain_root_url(subdomain: @subdomain)
  			expect(page.current_url).to include(@subdomain)
  		end

  		xit "does not allow account creation on subdomain" do
  			sign_user_in(user,subdomain: @subdomain)
  			expect { visit new_account_url(subdomain: subdomain)}.to raise_error ActionController::RoutingError
  		end
  end

  def sign_up(subdomain)
  	visit root_url(subdomain: false)
  	click_link "Create Account"

  	fill_in "account[owner_attributes][name]",with: "Ryan"
	fill_in "account[owner_attributes][email]",with: "bolandry@gmail.com"
	fill_in "account[owner_attributes][password]",with: "password"
	fill_in "account[owner_attributes][password_confirmation]",with: "password"
	fill_in "account[subdomain]",with: subdomain
	click_button "Submit"
  end

  def sign_user_in(user,opts={})
  	visit new_user_session_url(subdomain: opts[:subdomain])
  	fill_in "Email",with: user.email
  	fill_in "Password",with: (opts[:password] || user.password)
  	click_button "Sign in"
  end
end
