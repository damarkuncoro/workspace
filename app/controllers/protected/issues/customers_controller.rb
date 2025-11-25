class Protected::Issues::CustomersController < Protected::BaseController
  # Menetapkan customer dari rute nested
  before_action :set_customer
  before_action :authenticate_account!
  # Menyediakan koleksi akun yang dapat dipilih sebagai assignee
  before_action :set_assignable_accounts, only: %i[new edit]

  def index
    @issues = @customer.issues
  end

  def show
    @issue = @customer.issues.find(params[:id])
    @issue_comment = IssueComment.new
  end

  # GET /protected/customers/:customer_id/issues/new
  # Membuat instance Issue baru untuk customer (issueable polymorphic)
  def new
    @issue = Issue.new(issueable: @customer)
  end

  def create
    @issue = Issue.new(issue_params.except(:assigned_account_ids))
    @issue.issueable = @customer
    # Default: assign ke akun pembuat agar ada penanggung utama
    @issue.assigned_to = current_account if current_account.present?

    if @issue.save
      # Handle additional assignees
      if issue_params[:assigned_account_ids].present?
        issue_params[:assigned_account_ids].each do |account_id|
          @issue.issue_assignments.create(account_id: account_id) unless account_id.blank?
        end
      end
      redirect_to protected_customer_path(@customer), notice: "Issue for customer was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /protected/customers/:customer_id/issues/:id/edit
  # Mengedit issue untuk customer tertentu
  def edit
    @issue = @customer.issues.find(params[:id])
  end

  def update
    @issue = @customer.issues.find(params[:id])

    if @issue.update(issue_params.except(:assigned_account_ids))
      # Handle additional assignees - replace existing assignments
      @issue.issue_assignments.destroy_all
      if issue_params[:assigned_account_ids].present?
        issue_params[:assigned_account_ids].each do |account_id|
          @issue.issue_assignments.create(account_id: account_id) unless account_id.blank?
        end
      end
      redirect_to protected_customer_issue_path(@customer, @issue), notice: "Issue was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def create_comment
    @issue = @customer.issues.find(params[:id])
    @issue_comment = @issue.issue_comments.build(issue_comment_params)
    @issue_comment.account = current_account

    if @issue_comment.save
      redirect_to protected_customer_issue_path(@customer, @issue), notice: "Comment was successfully added."
    else
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    @issue = @customer.issues.find(params[:id])
    @issue.destroy

    redirect_to protected_customer_issues_path(@customer), notice: "Issue was successfully destroyed."
  end

  private

  def set_customer
    @customer = Customer.find(params[:customer_id])
  end

  # Menyediakan koleksi akun untuk pilihan assignee (primary dan additional)
  # Catatan: disusun dengan nama person agar mudah dipilih di UI.
  def set_assignable_accounts
    # Ambil akun dengan role yang relevan (employee/administrator) dan urutkan stabil
    @assignable_accounts = Account
      .left_joins(:account_roles, :roles)
      .where(account_roles: { revoked_at: nil }, roles: { name: ["employee", "administrator"] })
      .includes(:person)
      .order("accounts.created_at ASC")
  end

  def issue_comment_params
    params.require(:issue_comment).permit(:content, :internal)
  end

  def issue_params
    params.require(:issue).permit(:title, :description, :status, :priority, :assigned_to_id, assigned_account_ids: [])
  end

  def status_badge_class(status)
    case status
    when 'open'
      'bg-red-100 text-red-800'
    when 'in_progress'
      'bg-yellow-100 text-yellow-800'
    when 'completed'
      'bg-green-100 text-green-800'
    when 'closed'
      'bg-gray-100 text-gray-800'
    else
      'bg-gray-100 text-gray-800'
    end
  end

  def priority_badge_class(priority)
    case priority
    when 'high'
      'bg-red-100 text-red-800'
    when 'medium'
      'bg-yellow-100 text-yellow-800'
    when 'low'
      'bg-green-100 text-green-800'
    else
      'bg-blue-100 text-blue-800'
    end
  end
end
