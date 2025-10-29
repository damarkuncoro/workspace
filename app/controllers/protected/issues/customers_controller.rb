class Protected::Issues::CustomersController < Protected::BaseController
  before_action :set_customer
  before_action :authenticate_account!

  def index
    @issues = @customer.issues
  end

  def show
    @issue = @customer.issues.find(params[:id])
    @issue_comment = IssueComment.new
  end

  def new
    @issue = Issue.new(issueable: @customer)
  end

  def create
    @issue = Issue.new(issue_params.except(:assigned_account_ids))
    @issue.issueable = @customer

    if @issue.save
      # Handle additional assignees
      if issue_params[:assigned_account_ids].present?
        issue_params[:assigned_account_ids].each do |account_id|
          @issue.issue_assignments.create(account_id: account_id) unless account_id.blank?
        end
      end
      redirect_to customer_path(@customer), notice: "Issue for customer was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

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
      redirect_to customer_issue_path(@customer, @issue), notice: "Issue was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def create_comment
    @issue = @customer.issues.find(params[:id])
    @issue_comment = @issue.issue_comments.build(issue_comment_params)
    @issue_comment.account = current_account

    if @issue_comment.save
      redirect_to customer_issue_path(@customer, @issue), notice: "Comment was successfully added."
    else
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    @issue = @customer.issues.find(params[:id])
    @issue.destroy

    redirect_to customer_issues_path(@customer), notice: "Issue was successfully destroyed."
  end

  private

  def set_customer
    @customer = Customer.find(params[:customer_id])
  end

  def issue_comment_params
    params.require(:issue_comment).permit(:content, :internal)
  end

  def issue_params
    params.require(:issue).permit(:title, :description, :status, :priority, :assigned_to_id, assigned_account_ids: [])
  end
end
