class Protected::NetworkActivitiesController < Protected::BaseController
  before_action :set_network_activity, only: %i[show edit update destroy]

  def index
    @network_activities = NetworkActivity.includes(:network, :device, :device_interface).recent

    # Filter by network if provided
    @network_activities = @network_activities.where(network_id: params[:network_id]) if params[:network_id].present?

    # Filter by device if provided
    @network_activities = @network_activities.where(device_id: params[:device_id]) if params[:device_id].present?

    # Filter by device_interface if provided
    @network_activities = @network_activities.where(device_interface_id: params[:device_interface_id]) if params[:device_interface_id].present?

    # Filter by event_type if provided
    @network_activities = @network_activities.where(event_type: params[:event_type]) if params[:event_type].present?

    # Filter by date range
    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])
      @network_activities = @network_activities.where(recorded_at: start_date.beginning_of_day..end_date.end_of_day)
    end

    @pagy, @network_activities = pagy(@network_activities, items: 50)
    @networks = Network.all
    @devices = Device.all
  end

  def show
  end

  def new
    @network_activity = NetworkActivity.new
    @networks = Network.all
    @devices = Device.all
  end

  def create
    @network_activity = NetworkActivity.new(network_activity_params)

    if @network_activity.save
      redirect_to protected_network_activity_path(@network_activity), notice: "Network activity was successfully created."
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
    if @network_activity.update(network_activity_params)
      redirect_to protected_network_activity_path(@network_activity), notice: "Network activity was successfully updated."
    else
      @networks = Network.all
      @devices = Device.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @network_activity.destroy
    redirect_to protected_network_activities_path, notice: "Network activity was successfully deleted."
  end

  private

  def set_network_activity
    @network_activity = NetworkActivity.find(params[:id])
  end

  def network_activity_params
    params.require(:network_activity).permit(:network_id, :device_id, :device_interface_id, :event_type, :recorded_at, data: {})
  end
end