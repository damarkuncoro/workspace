class Protected::DashboardController < Protected::BaseController
  before_action :ensure_person_data_complete, only: %i[index]

  def index
    @person = current_account.person

    # Dashboard statistics
    @total_customers = Customer.count
    @total_employees = Employee.count
    @total_devices = Device.count
    @available_devices = Device.available.count
    @rented_devices = Device.rented.count

    # Recent activities
    @recent_customers = Customer.includes(:person).order(created_at: :desc).limit(5)
    @recent_issues = Issue.includes(:issueable).order(created_at: :desc).limit(5)

    # Device rental statistics
    @overdue_rentals = CustomerDevice.overdue.includes(:customer, :device)
    @current_rentals = CustomerDevice.current.includes(:customer, :device).limit(10)

    # Quick stats for admin
    if current_account.is_administrator?
      @pending_role_requests = RoleRequest.pending.count
      @total_accounts = Account.count
    end
  end

  private

  def ensure_person_data_complete
    # Redirect kalau belum isi data person
    if current_account.person.incomplete?
      redirect_to protected_profile_edit_path, alert: "Lengkapi profil Anda terlebih dahulu."
    end
  end
end
