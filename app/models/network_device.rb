class NetworkDevice < ApplicationRecord
  belongs_to :network
  belongs_to :device
  belongs_to :device_interface, optional: true
  has_many :network_activities, dependent: :destroy

  validates :network_id, presence: true
  validates :device_id, presence: true
  validates :status, inclusion: { in: %w[connected disconnected] }
  validates :network_id, uniqueness: { scope: :device_id }

  enum :status, {
    connected: "connected",
    disconnected: "disconnected"
  }

  # Scopes
  scope :connected, -> { where(status: 'connected') }
  scope :disconnected, -> { where(status: 'disconnected') }
  scope :by_network, ->(network_id) { where(network_id: network_id) }
  scope :by_device, ->(device_id) { where(device_id: device_id) }
  scope :by_status, ->(status) { where(status: status) }

  # Callbacks
  after_create :set_connected_at
  after_update :update_timestamps_on_status_change, if: :saved_change_to_status?

  # Methods
  def connection_duration
    return nil unless connected_at

    if disconnected?
      disconnected_at - connected_at if disconnected_at
    else
      Time.current - connected_at
    end
  end

  def formatted_connection_duration
    duration = connection_duration
    return 'N/A' unless duration

    if duration < 3600 # less than 1 hour
      "#{(duration / 60).to_i} minutes"
    elsif duration < 86400 # less than 1 day
      "#{(duration / 3600).to_i} hours"
    else
      "#{(duration / 86400).to_i} days"
    end
  end

  def recent_activities(limit = 10)
    network_activities.recent.limit(limit)
  end

  private

  def set_connected_at
    update_column(:connected_at, Time.current) if connected?
  end

  def update_timestamps_on_status_change
    if saved_change_to_status?
      if connected?
        update_column(:connected_at, Time.current)
        update_column(:disconnected_at, nil)
      elsif disconnected?
        update_column(:disconnected_at, Time.current)
      end
    end
  end
end