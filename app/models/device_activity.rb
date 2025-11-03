class DeviceActivity < ApplicationRecord
  belongs_to :customer_device

  validates :customer_device, presence: true
  validates :event_type, presence: true
  validates :recorded_at, presence: true

  # Scopes for different activity types
  scope :recent, -> { order(recorded_at: :desc) }
  scope :by_event_type, ->(event_type) { where(event_type: event_type) }

  # Common event types
  EVENT_TYPES = %w[
    rented
    returned
    overdue
    maintenance_started
    maintenance_completed
    config_updated
    damaged
    repaired
  ].freeze

  validates :event_type, inclusion: { in: EVENT_TYPES }

  # Helper method to create activity
  def self.log!(customer_device, event_type, data = {}, recorded_at = Time.current)
    create!(
      customer_device: customer_device,
      event_type: event_type,
      data: data,
      recorded_at: recorded_at
    )
  end

  # Get human readable description
  def description
    case event_type
    when 'rented'
      "Device rented to #{customer_device.customer.person_name}"
    when 'returned'
      "Device returned by #{customer_device.customer.person_name}"
    when 'overdue'
      "Device rental became overdue"
    when 'maintenance_started'
      "Device sent for maintenance"
    when 'maintenance_completed'
      "Device maintenance completed"
    when 'config_updated'
      "Device configuration updated"
    when 'damaged'
      "Device reported as damaged"
    when 'repaired'
      "Device repaired"
    else
      "#{event_type.humanize} event"
    end
  end
end
