class Device < ApplicationRecord
  belongs_to :device_type
  has_many :customer_devices, dependent: :restrict_with_error
  has_many :customers, through: :customer_devices

  # Add has_one association for current customer
  has_one :current_customer_device, -> { where(status: 'active') },
          class_name: 'CustomerDevice'
  has_one :current_customer, through: :current_customer_device, source: :customer

  # Network monitoring associations
  has_many :device_interfaces, dependent: :destroy
  has_many :network_devices, dependent: :destroy
  has_many :network_activities, dependent: :destroy
  has_many :networks, through: :network_devices

  validates :label, presence: true
  validates :serial_number, presence: true, uniqueness: true
  validates :status, presence: true
  validates :device_type, presence: true

  # Define enum - try with _prefix or _suffix option
  enum :status, {
    available: 0,
    rented: 1,
    maintenance: 2,
    retired: 3
  }
end