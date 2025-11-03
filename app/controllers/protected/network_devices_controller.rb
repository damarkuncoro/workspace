class Protected::NetworkDevicesController < Protected::BaseController
  before_action :set_network_device, only: %i[show edit update destroy]

  def index
    @network_devices = NetworkDevice.includes(:network, :device, :device_interface).order(created_at: :desc)

    # Filter by network if provided
    @network_devices = @network_devices.where(network_id: params[:network_id]) if params[:network_id].present?

    # Filter by device if provided
    @network_devices = @network_devices.where(device_id: params[:device_id]) if params[:device_id].present?

    # Filter by status if provided
    @network_devices = @network_devices.where(status: params[:status]) if params[:status].present?

    @pagy, @network_devices = pagy(@network_devices, items: 20)
    @networks = Network.all
    @devices = Device.all
  end

  def show
    @network_activities = NetworkActivity.where(network: @network_device.network, device: @network_device.device).recent.limit(50)
  end

  def new
    @network_device = NetworkDevice.new
    @networks = Network.all
    @devices = Device.all
  end

  def create
    @network_device = NetworkDevice.new(network_device_params)

    if @network_device.save
      redirect_to protected_network_device_path(@network_device), notice: "Network device was successfully created."
    else
      @networks = Network.all
      @devices = Device.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @networks = Network.all
    @devices = Device.all
  end

  def update
    if @network_device.update(network_device_params)
      redirect_to protected_network_device_path(@network_device), notice: "Network device was successfully updated."
    else
      @networks = Network.all
      @devices = Device.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @network_device.destroy
    redirect_to protected_network_devices_path, notice: "Network device was successfully deleted."
  end

  private

  def set_network_device
    @network_device = NetworkDevice.find(params[:id])
  end

  def network_device_params
    params.require(:network_device).permit(:network_id, :device_id, :device_interface_id, :ip_address, :status, metadata: {})
  end
end