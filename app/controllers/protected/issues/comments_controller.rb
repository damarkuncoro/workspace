class Protected::Issues::CommentsController < Protected::BaseController
  before_action :set_customer
  before_action :set_issue

  # create
  # Tujuan: Membuat komentar baru untuk sebuah Issue pada Customer
  # SRP: Bangun komentar dari params, set account, simpan, dan arahkan ulang
  # Output: Redirect ke halaman show issue atau render show dengan error
  def create
    @issue_comment = @issue.issue_comments.build(issue_comment_params)
    @issue_comment.account = current_account

    if @issue_comment.save
      redirect_to protected_customer_issue_path(@customer, @issue), notice: "Comment was successfully added."
    else
      # Jangan reset @issue_comment agar error tetap ditampilkan di form
      render "protected/issues/customers/show", status: :unprocessable_entity
    end
  end

  private

  # set_customer
  # Tujuan: Memuat Customer dari rute nested
  def set_customer
    @customer = Customer.find(params[:customer_id])
  end

  # set_issue
  # Tujuan: Memuat Issue berdasarkan customer dan issue_id dari rute
  def set_issue
    @issue = @customer.issues.find(params[:issue_id])
  end

  # issue_comment_params
  # Tujuan: Strong params untuk komentar issue
  def issue_comment_params
    params.require(:issue_comment).permit(:content, :internal)
  end
end
