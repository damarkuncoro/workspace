class Protected::Issues::CommentsController < Protected::BaseController
  before_action :set_customer
  before_action :set_issue

  def create
    @issue_comment = @issue.issue_comments.build(issue_comment_params)
    @issue_comment.account = current_account

    if @issue_comment.save
      redirect_to customer_issue_path(@customer, @issue), notice: "Comment was successfully added."
    else
      @issue_comment = IssueComment.new
      render 'protected/issues/customers/show', status: :unprocessable_entity
    end
  end

  private

  def set_customer
    @customer = Customer.find(params[:customer_id])
  end

  def set_issue
    @issue = @customer.issues.find(params[:issue_id])
  end

  def issue_comment_params
    params.require(:issue_comment).permit(:content, :internal)
  end
end