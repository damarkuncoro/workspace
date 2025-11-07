class Protected::AccountsController < Protected::AdministratorController
  before_action :set_account, only: %i[show edit update destroy]


  def index
    @accounts = Account.all
  end

  def show
  end


  def new
    # Inisialisasi akun baru dan bangun nested person agar fields_for :person muncul di form
    @account = Account.new
    @account.build_person unless @account.person
  end


  def edit
  end


  def create
    @account = Account.new(account_params)

    respond_to do |format|
      if @account.save
        format.html { redirect_to protected_account_path(@account), notice: "Account was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    # Remove password fields from params if they're blank (for updates)
    account_params_to_use = account_params.dup
    if account_params_to_use[:password].blank?
      account_params_to_use.delete(:password)
      account_params_to_use.delete(:password_confirmation)
    end

    respond_to do |format|
      if @account.update(account_params_to_use)
        format.html { redirect_to protected_account_path(@account), notice: "Account was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1 or /accounts/1.json
  def destroy
    @account.destroy

    respond_to do |format|
      format.html { redirect_to accounts_url, notice: "Account was successfully destroyed." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def account_params
      params.require(:account).permit(
        :email, :password, :password_confirmation,
        person_attributes: [ :name, :date_of_birth, :id ],
        role_ids: [])
    end
end
