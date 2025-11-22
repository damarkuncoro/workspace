class Protected::RolesController < Protected::BaseController
  before_action :set_roles, only: %i[show edit update]

  def index
    @roles = current_account.roles
  end
  # GET /roles (My Roles page without ID)
  # Menampilkan peran yang dimiliki oleh akun saat ini.
  # Catatan: Rute `protected_roles_show_path` tidak membawa :id,
  #          jadi kita TIDAK boleh melakukan find berdasarkan params[:id].
  def show
    # Tampilkan daftar roles; siapkan satu role pertama untuk detail jika view memerlukannya.
    @role = current_account.roles.first
  end

  # GET /roles/edit (Edit My Roles tanpa ID)
  # Menyediakan halaman edit untuk peran akun saat ini.
  def edit
    # Tidak ada :id pada rute ini, cukup gunakan koleksi @roles dari before_action.
  end

  # PATCH/PUT /protected/roles
  def update
    # Logic for updating roles if needed
    redirect_to protected_roles_path, notice: "Roles updated successfully."
  end

  private

  def set_roles
    @roles = current_account.roles
  end
end
