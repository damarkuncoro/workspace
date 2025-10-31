class Protected::EmployeesController < Protected::BaseController
  before_action :set_employee, only: %i[show edit update destroy]
  before_action :set_person, only: %i[new create]

  # GET /protected/employees
  def index
    @employees = Employee.all
  end

  # GET /protected/employees/new
  def new
    if @person.employee.present?
      redirect_to employee_path(@person.employee), notice: "Employee already exists for this person."
      return
    end
    # @employee di-set di set_person
    @employee ||= @person.build_employee
  end

  # GET /protected/employees/1
  def show
  end

  # GET /protected/employees/1/edit
  def edit
  end

  # POST /protected/employees
  def create
    @employee ||= @person.employee || @person.build_employee
    if @employee.update(employee_params)
      redirect_to employee_path(@employee), notice: "Employee was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /protected/employees/1
  def update
    if @employee.update(employee_params)
      redirect_to employee_path(@employee), notice: "Employee was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /protected/employees/1
  def destroy
    @employee.destroy
    redirect_to employees_path, notice: "Employee was successfully destroyed."
  end

  private

  # Set person for new/create actions
  def set_person
    if params[:account_id].present?
      @account = Account.find_by(id: params[:account_id])
      # build person jika belum ada
      @person = @account&.person || @account&.build_person
    else
      @person = current_account.person
    end

    # fallback jika person tetap nil
    @person ||= Person.new(account: current_account)
    # inisialisasi employee jika belum ada
    @employee ||= @person.employee
  end

  # Set employee for edit/update/destroy/show
  def set_employee
    @employee = Employee.find(params[:id])
  end

  # Strong params
  def employee_params
    params.require(:employee).permit(:status, :person_id)
  end
end
