class AccountsController < ApplicationController
  
  skip_before_action :authenticate_user!,only:[:new,:create]
  
  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      Apartment::Tenant.create(@account.subdomain)
      Apartment::Tenant.switch!(@account.subdomain)
      create_user(account_params[:owner_attributes])
      flash[:success] = "Signed up successfully."
      redirect_to new_user_session_url(subdomain: @account.subdomain)
    else
      render "new"
    end
  end
  
  private 
  def account_params
    params.require(:account).permit(:subdomain,owner_attributes:[:name,:email,:password,:password_confirmation ])
  end

  def create_user(params)
    User.create(params)
  end
end
