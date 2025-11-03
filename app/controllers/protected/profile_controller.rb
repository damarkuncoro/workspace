class Protected::ProfileController < Protected::BaseController
  before_action :set_person, only: %i[show edit update]

  # GET /protected/profile
  def show
    @customer = @person.customer if @person.customer.present?
    @employee = @person.employee if @person.employee.present?
  end

  def edit
  end
  # PATCH/PUT /protected/profile
  def update
    if @person.update(person_params)
      redirect_to protected_dashboard_path, notice: "Profil berhasil diperbarui."
    else
      redirect_to protected_profile_edit_path, alert: "Gagal memperbarui profil."
    end
  end



  private

  def set_person
    @person = current_account.person
  end

  def person_params
    params.require(:person).permit(:name, :date_of_birth)
  end
end
