class Network < ApplicationRecord
  has_many :network_devices, dependent: :destroy
  has_many :network_activities, dependent: :destroy
  has_many :devices, through: :network_devices
  has_many :device_interfaces, through: :network_devices
  has_many :link_connections, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :kind, presence: true, inclusion: { in: %w[lan wifi vpn wan] }

  enum :kind, {
    lan: "lan",
    wifi: "wifi",
    vpn: "vpn",
    wan: "wan"
  }

  # Scopes
  scope :by_kind, ->(kind) { where(kind: kind) }
  scope :search_by_name_or_location, ->(query) {
    where("name ILIKE ? OR location ILIKE ?", "%#{query}%", "%#{query}%")
  }

  # Methods
  def connected_devices_count
    network_devices.connected.count
  end

  def total_devices_count
    devices.count
  end

  def active_interfaces_count
    device_interfaces.distinct.count
  end
end