class Device < ApplicationRecord
  belongs_to :device_type
  has_many :customer_devices, dependent: :restrict_with_error
  has_many :customers, through: :customer_devices

  # Add has_one association for current customer
  has_one :current_customer_device, -> { where(status: 'active') }, class_name: 'CustomerDevice'
  has_one :current_customer, through: :current_customer_device, source: :customer

  validates :name, presence: true
  validates :serial_number, presence: true, uniqueness: true
  validates :status, presence: true, inclusion: { in: %w[available rented maintenance retired] }
  validates :device_type, presence: true

  # Scopes
  scope :available, -> { where(status: 'available') }
  scope :rented, -> { where(status: 'rented') }
  scope :in_maintenance, -> { where(status: 'maintenance') }
  scope :retired, -> { where(status: 'retired') }


  # Check if device is currently rented
  def rented?
    status == 'rented'
  end

  # Check if device is available for rent
  def available?
    status == 'available'
  end

  # Get current customer device (if rented)
  def current_customer_device
    customer_devices.where(status: 'active').first
  end

  # Get current customer (if rented)
  def current_customer
    current_customer_device&.customer
  end
  def maintenance
    []
  end
end


