class Protected::Issues::EmployeesController < Protected::BaseController
  before_action :set_employee
  before_action :authenticate_account!

  def index
    @issues = @employee.issues
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
      redirect_to employee_path(@employee), notice: "Issue for employee was successfully created."
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
      redirect_to employee_issue_path(@employee, @issue), notice: "Issue was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @issue = @employee.issues.find(params[:id])
    @issue.destroy

    redirect_to employee_issues_path(@employee), notice: "Issue was successfully destroyed."
  end

  private

  def set_employee
    @employee = Employee.find(params[:employee_id])
  end

  def issue_params
    params.require(:issue).permit(:title, :description, :status, :priority, :assigned_to_id, assigned_account_ids: [])
  end
end
