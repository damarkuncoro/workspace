class Protected::RolesController < Protected::BaseController
  before_action :set_roles, only: %i[show edit update]

  def index
    @roles = current_account.roles
  end
  # GET /protected/roles
  def show
    @roles = current_account.roles.find(params[:id])
  end

  def edit
    @roles = current_account.roles.find(params[:id])
  end

  # PATCH/PUT /protected/roles
  def update
    # Logic for updating roles if needed
    redirect_to protected_roles_path, notice: "Roles updated successfully."
  end

  private

  def set_roles
    @roles = current_account.roles
  end
end
