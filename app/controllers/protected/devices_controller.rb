class Protected::DevicesController < Protected::BaseController
  before_action :set_device, only: %i[show edit update destroy schema]

  def index
    @devices = Device.includes(:device_type, :current_customer).order(created_at: :desc)

    # Filter by status if provided
    @devices = @devices.where(status: params[:status]) if params[:status].present?

    # Filter by device type if provided
    @devices = @devices.where(device_type_id: params[:device_type_id]) if params[:device_type_id].present?

    # Search by name or serial number
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @devices = @devices.where("name ILIKE ? OR serial_number ILIKE ?", search_term, search_term)
    end

    @pagy, @devices = pagy(@devices, items: 20)
    @device_types = DeviceType.all
  end

  def show
    @customer_devices = @device.customer_devices.includes(:customer).order(created_at: :desc)
    @device_activities = @device.customer_devices.flat_map(&:device_activities).sort_by(&:recorded_at).reverse
  end

  def schema
    render json: { schema: @device.configuration_schema }
  end

  def new
    @device = Device.new
    @device_types = DeviceType.all
  end

  def create
    @device = Device.new(device_params)

    if @device.save
      redirect_to protected_device_path(@device), notice: "Device was successfully created."
    else
      @device_types = DeviceType.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @device_types = DeviceType.all
  end

  def update
    if @device.update(device_params)
      redirect_to protected_device_path(@device), notice: "Device was successfully updated."
    else
      @device_types = DeviceType.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @device.customer_devices.active.exists?
      redirect_to protected_devices_path, alert: "Cannot delete device that is currently rented."
    else
      @device.destroy
      redirect_to protected_devices_path, notice: "Device was successfully deleted."
    end
  end

  private

  def set_device
    @device = Device.find(params[:id])
  end

  def device_params
    params.require(:device).permit(:label, :name, :serial_number, :device_type_id, :status, default_config: {}, config: {}).tap do |whitelisted|
      # Handle JSON textarea input
      if whitelisted[:default_config].is_a?(String) && whitelisted[:default_config].present?
        begin
          whitelisted[:default_config] = JSON.parse(whitelisted[:default_config])
        rescue JSON::ParserError
          whitelisted[:default_config] = {}
        end
      end

      # Handle form-based config input and merge with default_config
      if whitelisted[:config].present?
        whitelisted[:default_config] ||= {}
        whitelisted[:default_config].merge!(whitelisted[:config])
      end

      # Remove the temporary config param
      whitelisted.delete(:config)
    end
  end
end
