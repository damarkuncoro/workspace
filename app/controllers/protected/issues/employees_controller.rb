class Protected::Issues::EmployeesController < Protected::BaseController
  before_action :set_employee
  before_action :authenticate_account!

  # Action: Index
  # Tujuan: Menampilkan daftar issues untuk karyawan dengan dukungan filter status, priority, dan pencarian.
  # Prinsip: SRP & KISS — logika filter dipisah ke helper private untuk keterbacaan.
  def index
    base_scope = @employee.issues.includes(:assigned_to, :issue_assignments)
    @issues     = apply_filters(base_scope)

    # Opsi untuk dropdown filter pada toolbar
    @status_options   = Issue.statuses.keys
    @priority_options = Issue.priorities.keys
  end

  def show
    @issue = @employee.issues.find(params[:id])
  end

  def new
    @issue = Issue.new(issueable: @employee)
  end

  def create
    @issue = Issue.new(issue_params.except(:assigned_account_ids))
    @issue.issueable = @employee
    @issue.assigned_to = current_account # opsional, assign otomatis ke creator

    if @issue.save
      # Handle additional assignees
      if issue_params[:assigned_account_ids].present?
        issue_params[:assigned_account_ids].each do |account_id|
          @issue.issue_assignments.create(account_id: account_id) unless account_id.blank?
        end
      end
      redirect_to protected_employee_path(@employee), notice: "Issue for employee was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @issue = @employee.issues.find(params[:id])
  end

  def update
    @issue = @employee.issues.find(params[:id])

    if @issue.update(issue_params.except(:assigned_account_ids))
      # Handle additional assignees - replace existing assignments
      @issue.issue_assignments.destroy_all
      if issue_params[:assigned_account_ids].present?
        issue_params[:assigned_account_ids].each do |account_id|
          @issue.issue_assignments.create(account_id: account_id) unless account_id.blank?
        end
      end
      # Redirect ke show issue dengan helper namespaced
      redirect_to protected_employee_issue_path(@employee, @issue), notice: "Issue was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # Hapus Issue untuk Employee, lalu kembali ke daftar issues (namespaced)
  def destroy
    @issue = @employee.issues.find(params[:id])
    @issue.destroy

    redirect_to protected_employee_issues_path(@employee), notice: "Issue was successfully destroyed."
  end

  private

  def set_employee
    @employee = Employee.find(params[:employee_id])
  end

  # Method: apply_filters
  # Tujuan: Terapkan filter berbasis params (:status, :priority, :search) ke scope issues.
  # Input: ActiveRecord::Relation (scope issues)
  # Output: ActiveRecord::Relation ter-filter
  def apply_filters(scope)
    filtered = scope

    # Filter status (enum string: 'open', 'in_progress', 'completed', 'closed')
    filtered = filtered.where(status: params[:status]) if params[:status].present?

    # Filter priority (enum string: 'low', 'medium', 'high')
    filtered = filtered.where(priority: params[:priority]) if params[:priority].present?

    # Pencarian sederhana pada title & description
    if params[:search].present?
      term = "%#{params[:search]}%"
      filtered = filtered.where("title ILIKE ? OR description ILIKE ?", term, term)
    end

    filtered.order(created_at: :desc)
  end

  def issue_params
    params.require(:issue).permit(:title, :description, :status, :priority, :assigned_to_id, assigned_account_ids: [])
  end
end
