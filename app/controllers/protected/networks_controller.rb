class Protected::NetworksController < Protected::BaseController
  before_action :set_network, only: %i[show edit update destroy]

  def index
    @networks = Network.includes(:devices).order(created_at: :desc)

    # Filter by kind if provided
    @networks = @networks.where(kind: params[:kind]) if params[:kind].present?

    # Search by name or location
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @networks = @networks.where("name ILIKE ? OR location ILIKE ?", search_term, search_term)
    end

    @pagy, @networks = pagy(@networks, items: 20)
  end

  def show
    @network_devices = @network.network_devices.includes(:device, :device_interface).order(created_at: :desc)
    @network_activities = NetworkActivity.where(network: @network).recent.limit(50)
  end

  def new
    @network = Network.new
  end

  def create
    @network = Network.new(network_params)

    if @network.save
      redirect_to protected_network_path(@network), notice: "Network was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @network.update(network_params)
      redirect_to protected_network_path(@network), notice: "Network was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @network.network_devices.exists?
      redirect_to protected_networks_path, alert: "Cannot delete network that has connected devices."
    else
      @network.destroy
      redirect_to protected_networks_path, notice: "Network was successfully deleted."
    end
  end

  private

  def set_network
    @network = Network.find(params[:id])
  end

  def network_params
    params.require(:network).permit(:name, :kind, :cidr, :location, metadata: {})
  end
end