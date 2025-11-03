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
  scope :by_date_range, ->(start_date, end_date) {
    where(recorded_at: start_date.beginning_of_day..end_date.end_of_day)
  }

  # Methods
  def event_icon
    case event_type
    when 'link_up' then 'link-up'
    when 'link_down' then 'link-down'
    when 'dhcp_assigned' then 'dhcp'
    when 'ip_change' then 'ip-change'
    when 'auth_fail' then 'auth-fail'
    when 'rssi' then 'signal'
    else 'activity'
    end
  end

  def event_color
    case event_type
    when 'link_up' then 'green'
    when 'link_down', 'auth_fail' then 'red'
    when 'dhcp_assigned', 'ip_change' then 'blue'
    when 'rssi' then 'yellow'
    else 'gray'
    end
  end

  def formatted_data
    return nil unless data.present?
    data.is_a?(Hash) ? data : JSON.parse(data.to_s) rescue nil
  end

  def related_entities
    [network, device, device_interface].compact
  end

  def description
    case event_type
    when 'link_up'
      "#{device&.label || 'Device'} connected to #{network&.name || 'network'}"
    when 'link_down'
      "#{device&.label || 'Device'} disconnected from #{network&.name || 'network'}"
    when 'dhcp_assigned'
      "IP #{formatted_data&.dig('ip_address')} assigned to #{device&.label || 'device'}"
    when 'ip_change'
      "IP changed from #{formatted_data&.dig('old_ip')} to #{formatted_data&.dig('new_ip')}"
    when 'auth_fail'
      "Authentication failed for #{device&.label || 'device'}"
    when 'rssi'
      "Signal strength: #{formatted_data&.dig('rssi')}dBm"
    else
      "#{event_type.titleize} event"
    end
  end
end