class Protected::DashboardController < Protected::BaseController
  before_action :ensure_person_data_complete, only: %i[index]

  def index
    @person = current_account.person
    # Konten dashboard di sini...
  end

  private

  def ensure_person_data_complete
    # Redirect kalau belum isi data person
    if current_account.person.incomplete?
      redirect_to profile_edit_path, alert: "Lengkapi profil Anda terlebih dahulu."
    end
  end
end
