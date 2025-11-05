class Protected::DashboardController < Protected::BaseController
  before_action :ensure_person_data_complete, only: %i[index]

  def index
    @person = current_account.person

    # Core dashboard statistics
    @total_accounts = Account.count
    @total_customers = Customer.count
    @total_employees = Employee.count
    @total_devices = Device.count
    @available_devices = Device.available.count
    @rented_devices = Device.rented.count

    # Network statistics
    @total_networks = Network.count
    @total_device_interfaces = DeviceInterface.count
    @total_network_devices = NetworkDevice.count
    @total_network_activities = NetworkActivity.count

    # Issue tracking statistics
    @total_issues = Issue.count
    @open_issues = Issue.where(status: 'open').count
    @resolved_issues = Issue.where(status: 'resolved').count
    @pending_issues = Issue.where(status: 'pending').count

    # Recent activities (last 7 days)
    @recent_customers = Customer.includes(:person).where('created_at >= ?', 7.days.ago).order(created_at: :desc).limit(5)
    @recent_issues = Issue.includes(:issueable).where('created_at >= ?', 7.days.ago).order(created_at: :desc).limit(5)
    @recent_device_activities = DeviceActivity.where('created_at >= ?', 7.days.ago).order(created_at: :desc).limit(5)

    # Device rental statistics
    @overdue_rentals = CustomerDevice.overdue.includes(:customer, :device)
    @current_rentals = CustomerDevice.current.includes(:customer, :device).limit(10)
    @returned_today = CustomerDevice.where('updated_at >= ? AND status = ?', Time.current.beginning_of_day, 'returned').count

    # Today's metrics
    @customers_today = Customer.where('created_at >= ?', Time.current.beginning_of_day).count
    @rentals_today = CustomerDevice.where('created_at >= ?', Time.current.beginning_of_day).count
    @issues_today = Issue.where('created_at >= ?', Time.current.beginning_of_day).count

    # Quick stats for admin
    if current_account.is_administrator?
      @pending_role_requests = RoleRequest.pending.count
      @total_device_types = DeviceType.count
      @active_networks = Network.count # Networks don't have status column, so count all
    end

    # System health indicators
    @system_health = {
      database: true, # Assume healthy unless we have monitoring
      api_services: true,
      device_sync: rand > 0.1, # Simulate sync status
      network_monitoring: @total_network_activities > 0
    }
  end

  private

  def ensure_person_data_complete
    # Redirect kalau belum isi data person
    if current_account.person.incomplete?
      redirect_to protected_profile_edit_path, alert: "Lengkapi profil Anda terlebih dahulu."
    end
  end
end
