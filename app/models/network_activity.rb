class NetworkActivity < ApplicationRecord
  belongs_to :network, optional: true
  belongs_to :device, optional: true
  belongs_to :device_interface, optional: true

  validates :event_type, presence: true
  validates :recorded_at, presence: true

  enum :event_type, {
    dhcp_assigned: "dhcp_assigned",
    link_up: "link_up",
    link_down: "link_down",
    ip_change: "ip_change",
    auth_fail: "auth_fail",
    rssi: "rssi"
  }

  # Scopes
  scope :by_event_type, ->(event_type) { where(event_type: event_type) }
  scope :recent, -> { order(recorded_at: :desc) }
  scope :for_network, ->(network_id) { where(network_id: network_id) }
  scope :for_device, ->(device_id) { where(device_id: device_id) }
  scope :for_device_interface, ->(device_interface_id) { where(device_interface_id: device_interface_id) }
end