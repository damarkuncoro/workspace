class Protected::Issues::CommentsController < Protected::BaseController
  before_action :set_parent
  before_action :set_issue

  # create
  # Tujuan: Membuat komentar baru untuk sebuah Issue pada Customer/Employee
  # SRP: Bangun komentar dari params, set account, simpan, dan arahkan ulang
  # Output: Redirect ke halaman show issue sesuai parent atau render show dengan error
  def create
    @issue_comment = @issue.issue_comments.build(issue_comment_params)
    @issue_comment.account = current_account

    if @issue_comment.save
      if @customer.present?
        redirect_to protected_customer_issue_path(@customer, @issue), notice: "Comment was successfully added."
      elsif @employee.present?
        redirect_to protected_employee_issue_path(@employee, @issue), notice: "Comment was successfully added."
      else
        redirect_to protected_issues_path, notice: "Comment was successfully added."
      end
    else
      # Jangan reset @issue_comment agar error tetap ditampilkan di form
      if @customer.present?
        render "protected/issues/customers/show", status: :unprocessable_entity
      elsif @employee.present?
        render "protected/issues/employees/show", status: :unprocessable_entity
      else
        head :unprocessable_entity
      end
    end
  end

  private

  # set_parent
  # Tujuan: Memuat parent polymorphic (Customer atau Employee) dari rute nested
  def set_parent
    if params[:customer_id].present?
      @customer = Customer.find(params[:customer_id])
    elsif params[:employee_id].present?
      @employee = Employee.find(params[:employee_id])
    end
  end

  # set_issue
  # Tujuan: Memuat Issue berdasarkan parent yang aktif dan issue_id dari rute
  def set_issue
    if @customer.present?
      @issue = @customer.issues.find(params[:issue_id])
    elsif @employee.present?
      @issue = @employee.issues.find(params[:issue_id])
    else
      @issue = Issue.find(params[:issue_id])
    end
  end

  # issue_comment_params
  # Tujuan: Strong params untuk komentar issue
  def issue_comment_params
    params.require(:issue_comment).permit(:content, :internal)
  end
end
