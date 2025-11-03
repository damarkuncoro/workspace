class DeviceInterface < ApplicationRecord
  belongs_to :device
  has_many :network_devices, dependent: :destroy
  has_many :network_activities, dependent: :destroy
  has_many :networks, through: :network_devices
  has_many :link_connections, dependent: :destroy

  validates :device_id, presence: true
  validates :mac, presence: true, uniqueness: true
  validates :link_type, inclusion: { in: %w[ethernet wifi virtual], allow_blank: true }

  enum :link_type, {
    ethernet: "ethernet",
    wifi: "wifi",
    virtual: "virtual"
  }

  # Scopes
  scope :by_device, ->(device_id) { where(device_id: device_id) }
  scope :by_link_type, ->(link_type) { where(link_type: link_type) }
  scope :search_by_name_or_mac, ->(query) {
    where("name ILIKE ? OR mac ILIKE ?", "%#{query}%", "%#{query}%")
  }

  # Methods
  def connected_networks_count
    networks.distinct.count
  end

  def active_connections_count
    network_devices.connected.count
  end

  def total_activities_count
    network_activities.count
  end
end