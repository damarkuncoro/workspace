class Protected::DeviceTypesController < Protected::BaseController
  before_action :set_device_type, only: %i[show edit update destroy schema]

  def index
    @device_types = DeviceType.includes(:devices).order(created_at: :desc)

    # Search by name if provided
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @device_types = @device_types.where("name ILIKE ?", search_term)
    end

    @pagy, @device_types = pagy(@device_types, items: 20)
  end

  def show
    @devices = @device_type.devices.includes(:current_customer).order(created_at: :desc)
  end

  def schema
    render json: { schema: @device_type.schema }
  end

  def new
    @device_type = DeviceType.new
  end

  def create
    @device_type = DeviceType.new(device_type_params)

    if @device_type.save
      redirect_to protected_device_type_path(@device_type), notice: "Device type was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @device_type.update(device_type_params)
      redirect_to protected_device_type_path(@device_type), notice: "Device type was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @device_type.devices.exists?
      redirect_to protected_device_types_path, alert: "Cannot delete device type that has associated devices."
    else
      @device_type.destroy
      redirect_to protected_device_types_path, notice: "Device type was successfully deleted."
    end
  end

  private

  def set_device_type
    @device_type = DeviceType.find(params[:id])
  end

  def device_type_params
    params.require(:device_type).permit(:name, :description, :schema)
  end
end
