class Protected::CustomersController < Protected::BaseController
  before_action :set_customer, only: %i[show edit update destroy]
  before_action :set_person, only: %i[new]

  # GET /protected/customers
  def index
    @customers = Customer.all
  end

  # GET /protected/customers/new
  def new
    if @person.customer.present?
      redirect_to customer_path(@person.customer), notice: "Customer already exists for this person."
      return
    end
    # @customer di-set di set_person
    @customer ||= @person.build_customer
  end

  # GET /protected/customers/1
  def show
  end

  # GET /protected/customers/1/edit
  def edit
  end

  # POST /protected/customers
  def create
    @customer ||= @person.customer || @person.build_customer
    if @customer.update(customer_params)
      redirect_to customer_path(@customer), notice: "Customer was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /protected/customers/1
  def update
    if @customer.update(customer_params)
      redirect_to @customer, notice: "Customer was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /protected/customers/1
  def destroy
    @customer.destroy
    redirect_to customers_path, notice: "Customer was successfully destroyed."
  end

  private

  def set_person
    if params[:account_id].present?
      @account = Account.find(params[:account_id])
      @person = @account.person if @account.person.present?
    else
      @person = Person.find(params[:person_id]) if params[:person_id].present?
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_customer
    @customer = Customer.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def customer_params
    params.require(:customer).permit(:person_id, :status)
  end
end
