class Frontend::BaseController < ApplicationController
  before_action :redirect_authenticated_users

  private

  def redirect_authenticated_users
    if account_signed_in?
      redirect_to protected_dashboard_path
    end
  end
end
