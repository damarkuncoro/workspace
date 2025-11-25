class Protected::PeopleController < Protected::BaseController
  before_action :set_person, only: %i[show edit update destroy]

  def index
    @people = Person.order(created_at: :desc)
  end

  def show
  end

  def new
    @person = current_account.person || current_account.build_person
  end

  def create
    @person = current_account.person || current_account.build_person
    if @person.update(person_params)
      redirect_to protected_person_path(@person), notice: "Person was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @person.update(person_params)
      redirect_to protected_person_path(@person), notice: "Person was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @person.destroy
    redirect_to protected_people_path, notice: "Person was successfully destroyed."
  end

  private
  def set_person
    @person = Person.find(params[:id])
  end

  def person_params
    # Strong params: hanya field yang ada pada tabel people
    # Hindari :metadata karena kolom tersebut tidak ada di people
    params.require(:person).permit(:name, :date_of_birth)
  end
end