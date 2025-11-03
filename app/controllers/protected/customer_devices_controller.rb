class Protected::CustomerDevicesController < Protected::BaseController
  before_action :set_customer_device, only: %i[show edit update destroy return]
  before_action :set_customer, only: %i[index new create edit]

  def index
    @customer_devices = @customer.customer_devices.includes(:device).order(created_at: :desc)

    # Filter by status if provided
    @customer_devices = @customer_devices.where(status: params[:status]) if params[:status].present?

    # Filter by device type if provided
    if params[:device_type_id].present?
      @customer_devices = @customer_devices.joins(device: :device_type).where(devices: { device_type_id: params[:device_type_id] })
    end

    # Search by device name or serial number
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @customer_devices = @customer_devices.joins(:device).where("devices.name ILIKE ? OR devices.serial_number ILIKE ?", search_term, search_term)
    end

    @pagy, @customer_devices = pagy(@customer_devices, items: 20)
    @device_types = DeviceType.all
  end

  def show
    @device_activities = @customer_device.device_activities.order(recorded_at: :desc)
  end

  def new
    @customer_device = CustomerDevice.new
    @available_devices = Device.available.includes(:device_type)

    # Filter by device type if provided
    @available_devices = @available_devices.where(device_type_id: params[:device_type_id]) if params[:device_type_id].present?

    @device_types = DeviceType.all
  end

  def create
    @customer_device = CustomerDevice.new(customer_device_params)
    @customer_device.customer = @customer

    if @customer_device.save
      # Update device status to rented
      @customer_device.device.update!(status: 'rented')

      redirect_to protected_customer_device_path(@customer, @customer_device), notice: "Device rental was successfully created."
    else
      @available_devices = Device.available.includes(:device_type)
      @device_types = DeviceType.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @device_types = DeviceType.all
  end

  def update
    if @customer_device.update(customer_device_params)
      redirect_to protected_customer_device_path(@customer_device.customer, @customer_device), notice: "Device rental was successfully updated."
    else
      @device_types = DeviceType.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    device = @customer_device.device

    if @customer_device.destroy
      # Update device status back to available if no other active rentals
      device.update!(status: 'available') unless device.customer_devices.active.exists?

      redirect_to protected_customer_devices_path(@customer_device.customer), notice: "Device rental was successfully ended."
    else
      redirect_to protected_customer_device_path(@customer_device.customer, @customer_device), alert: "Could not end device rental."
    end
  end

  def return
    if @customer_device.return_device!(Time.current)
      redirect_to protected_customer_device_path(@customer_device.customer, @customer_device), notice: "Device was successfully returned."
    else
      redirect_to protected_customer_device_path(@customer_device.customer, @customer_device), alert: "Could not return device."
    end
  end

  private

  def set_customer_device
    @customer_device = CustomerDevice.find(params[:id])
  end

  def set_customer
    @customer = Customer.find(params[:customer_id])
  end

  def customer_device_params
    params.require(:customer_device).permit(:device_id, :rented_from, :rented_until, :config, :notes).tap do |whitelisted|
      if whitelisted[:config].is_a?(String) && whitelisted[:config].present?
        begin
          whitelisted[:config] = JSON.parse(whitelisted[:config])
        rescue JSON::ParserError
          whitelisted[:config] = nil
        end
      end
    end
  end
end
