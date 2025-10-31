class Protected::AdministratorController < Protected::BaseController
  before_action :require_administrator

  private
  def require_administrator
      unless current_account.is_administrator?
        redirect_to dashboard_index_path, alert: "Access denied. Administrator role required."
      end
  end
end
