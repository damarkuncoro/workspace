class Protected::LinkConnectionsController < Protected::BaseController
  before_action :set_link_connection, only: %i[show edit update destroy]

  def index
    @link_connections = LinkConnection.includes(:device_interface_a, :device_interface_b, :network).order(created_at: :desc)

    # Filter by link type if provided
    @link_connections = @link_connections.where(link_type: params[:link_type]) if params[:link_type].present?

    # Filter by status if provided
    @link_connections = @link_connections.where(status: params[:status]) if params[:status].present?

    # Filter by device if provided
    if params[:device_id].present?
      @link_connections = @link_connections.where(
        "device_interface_a_id IN (SELECT id FROM device_interfaces WHERE device_id = ?) OR
         device_interface_b_id IN (SELECT id FROM device_interfaces WHERE device_id = ?)",
        params[:device_id], params[:device_id]
      )
    end

    # Search by device names or interface names
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @link_connections = @link_connections.joins(
        "INNER JOIN device_interfaces dia ON dia.id = link_connections.device_interface_a_id
         INNER JOIN device_interfaces dib ON dib.id = link_connections.device_interface_b_id
         INNER JOIN devices da ON da.id = dia.device_id
         INNER JOIN devices db ON db.id = dib.device_id"
      ).where(
        "da.label ILIKE ? OR db.label ILIKE ? OR dia.name ILIKE ? OR dib.name ILIKE ?",
        search_term, search_term, search_term, search_term
      )
    end

    @pagy, @link_connections = pagy(@link_connections, items: 20)
    @devices = Device.all
    @networks = Network.all
  end

  def show
    # Set device and interface variables for the view
    @device_a = @link_connection.device_a
    @device_b = @link_connection.device_b
    @interface_a = @link_connection.device_interface_a
    @interface_b = @link_connection.device_interface_b

    # Find connection path between the two devices
    @connection_path = LinkConnection.find_connection_path(
      @link_connection.device_a.id,
      @link_connection.device_b.id
    )

    # Get all connected devices from device_a
    @connected_devices_a = LinkConnection.get_connected_devices(@link_connection.device_a.id)

    # Get all connected devices from device_b
    @connected_devices_b = LinkConnection.get_connected_devices(@link_connection.device_b.id)
  end

  def new
    @link_connection = LinkConnection.new
    @devices = Device.all
    @device_interfaces = DeviceInterface.all
  end

  def create
    @link_connection = LinkConnection.new(link_connection_params)

    if @link_connection.save
      redirect_to protected_link_connection_path(@link_connection), notice: "Link connection was successfully created."
    else
      @devices = Device.all
      @device_interfaces = DeviceInterface.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @devices = Device.all
    @device_interfaces = DeviceInterface.all
  end

  def update
    if @link_connection.update(link_connection_params)
      redirect_to protected_link_connection_path(@link_connection), notice: "Link connection was successfully updated."
    else
      @devices = Device.all
      @device_interfaces = DeviceInterface.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @link_connection.destroy
    redirect_to protected_link_connections_path, notice: "Link connection was successfully deleted."
  end

  # Custom action untuk mencari jalur koneksi
  def find_path
    start_device_id = params[:start_device_id]
    end_device_id = params[:end_device_id]

    if start_device_id.present? && end_device_id.present?
      @connection_path = LinkConnection.find_connection_path(start_device_id, end_device_id)
      @start_device = Device.find(start_device_id)
      @end_device = Device.find(end_device_id)
    end

    @devices = Device.all
  end

  private

  def set_link_connection
    @link_connection = LinkConnection.find(params[:id])
  end

  def link_connection_params
    params.require(:link_connection).permit(
      :device_interface_a_id,
      :device_interface_b_id,
      :network_id,
      :link_type,
      :status,
      :bandwidth_mbps,
      :latency_ms,
      metadata: {}
    )
  end
end