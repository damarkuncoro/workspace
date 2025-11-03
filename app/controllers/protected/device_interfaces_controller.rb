class Protected::DeviceInterfacesController < Protected::BaseController
  before_action :set_device_interface, only: %i[show edit update destroy]

  def index
    @device_interfaces = DeviceInterface.includes(:device).order(created_at: :desc)

    # Filter by device if provided
    @device_interfaces = @device_interfaces.where(device_id: params[:device_id]) if params[:device_id].present?

    # Filter by link_type if provided
    @device_interfaces = @device_interfaces.where(link_type: params[:link_type]) if params[:link_type].present?

    # Search by name or MAC
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @device_interfaces = @device_interfaces.where("name ILIKE ? OR mac ILIKE ?", search_term, search_term)
    end

    @pagy, @device_interfaces = pagy(@device_interfaces, items: 20)
    @devices = Device.all
  end

  def show
    @network_devices = @device_interface.network_devices.includes(:network).order(created_at: :desc)
    @network_activities = NetworkActivity.where(device_interface: @device_interface).recent.limit(50)
  end

  def new
    @device_interface = DeviceInterface.new
    @devices = Device.all
  end

  def create
    @device_interface = DeviceInterface.new(device_interface_params)

    if @device_interface.save
      redirect_to protected_device_interface_path(@device_interface), notice: "Device interface was successfully created."
    else
      @devices = Device.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @devices = Device.all
  end

  def update
    if @device_interface.update(device_interface_params)
      redirect_to protected_device_interface_path(@device_interface), notice: "Device interface was successfully updated."
    else
      @devices = Device.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @device_interface.network_devices.exists?
      redirect_to protected_device_interfaces_path, alert: "Cannot delete device interface that is connected to networks."
    else
      @device_interface.destroy
      redirect_to protected_device_interfaces_path, notice: "Device interface was successfully deleted."
    end
  end

  private

  def set_device_interface
    @device_interface = DeviceInterface.find(params[:id])
  end

  def device_interface_params
    params.require(:device_interface).permit(:device_id, :name, :mac, :link_type, metadata: {})
  end
end