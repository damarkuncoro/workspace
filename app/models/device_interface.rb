class DeviceInterface < ApplicationRecord
  belongs_to :device
  has_many :network_devices, dependent: :destroy
  has_many :network_activities, dependent: :destroy
  has_many :networks, through: :network_devices

  validates :device_id, presence: true
  validates :mac, presence: true, uniqueness: true
  validates :link_type, inclusion: { in: %w[ethernet wifi virtual], allow_blank: true }

  enum :link_type, {
    ethernet: "ethernet",
    wifi: "wifi",
    virtual: "virtual"
  }
end