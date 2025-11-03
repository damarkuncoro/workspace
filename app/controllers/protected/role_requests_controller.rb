class Protected::RoleRequestsController < Protected::BaseController
  before_action :set_role_request, only: %i[show approve reject cancel]

  # GET /protected/role_requests
  def index
    @role_requests = if current_account.is_administrator?
                       RoleRequest.all.includes(:role, :account, :requested_by, :approved_by)
                     else
                       RoleRequest.for_account(current_account).or(RoleRequest.by_requester(current_account)).includes(:role, :account, :requested_by, :approved_by)
                     end
    @role_requests = @role_requests.order(created_at: :desc)
  end

  # GET /protected/role_requests/new
  def new
    @role_request = RoleRequest.new
    @available_roles = Role.where.not(id: current_account.roles.pluck(:id))
  end

  # POST /protected/role_requests
  def create
    @role_request = RoleRequest.new(role_request_params)
    @role_request.account = current_account
    @role_request.requested_by = current_account

    if @role_request.save
      redirect_to protected_role_requests_path, notice: 'Role request submitted successfully.'
    else
      @available_roles = Role.where.not(id: current_account.roles.pluck(:id))
      render :new
    end
  end

  # GET /protected/role_requests/:id
  def show
  end

  # PATCH /protected/role_requests/:id/approve
  def approve
    if current_account.is_administrator?
      @role_request.approve!(current_account)
      # Actually assign the role
      @role_request.account.add_role(@role_request.role.name, current_account)
      redirect_to protected_role_requests_path, notice: 'Role request approved and role assigned.'
    else
      redirect_to protected_role_requests_path, alert: 'You are not authorized to approve role requests.'
    end
  end

  # PATCH /protected/role_requests/:id/reject
  def reject
    if current_account.is_administrator?
      @role_request.reject!(current_account)
      redirect_to protected_role_requests_path, notice: 'Role request rejected.'
    else
      redirect_to protected_role_requests_path, alert: 'You are not authorized to reject role requests.'
    end
  end

  # PATCH /protected/role_requests/:id/cancel
  def cancel
    if @role_request.requested_by == current_account && @role_request.pending?
      @role_request.cancel!
      redirect_to protected_role_requests_path, notice: 'Role request cancelled.'
    else
      redirect_to protected_role_requests_path, alert: 'You cannot cancel this role request.'
    end
  end

  private

  def set_role_request
    @role_request = RoleRequest.find(params[:id])
  end

  def role_request_params
    params.require(:role_request).permit(:role_id, :comment)
  end
end
