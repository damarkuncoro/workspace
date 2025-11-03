class Network < ApplicationRecord
  has_many :network_devices, dependent: :destroy
  has_many :network_activities, dependent: :destroy
  has_many :devices, through: :network_devices

  validates :name, presence: true, uniqueness: true
  validates :kind, presence: true, inclusion: { in: %w[lan wifi vpn wan] }

  enum :kind, {
    lan: "lan",
    wifi: "wifi",
    vpn: "vpn",
    wan: "wan"
  }
end