class CustomerDevice < ApplicationRecord
  belongs_to :customer
  belongs_to :device
  has_many :device_activities, dependent: :destroy

  validates :customer_id, presence: true
  validates :device_id, presence: true
  validates :rented_from, presence: true
  validates :status, presence: true, inclusion: { in: %w[active returned overdue cancelled] }

  # Ensure unique customer-device combination
  validates :device_id, uniqueness: { scope: :customer_id, message: "is already rented by this customer" }

  # Ensure device is available when creating rental
  validate :device_must_be_available, on: :create
  validate :rented_until_must_be_after_rented_from, if: -> { rented_until.present? }

  # Scopes
  scope :active, -> { where(status: 'active') }
  scope :returned, -> { where(status: 'returned') }
  scope :overdue, -> { where(status: 'overdue') }
  scope :current, -> { where(status: 'active').where('rented_until >= ?', Date.current) }

  # Callbacks
  after_create :update_device_status_to_rented
  after_update :update_device_status_on_return, if: :saved_change_to_status?

  # Check if rental is overdue
  def overdue?
    status == 'active' && rented_until.present? && rented_until < Date.current
  end

  # Check if rental is currently active
  def active?
    status == 'active'
  end

  # Return the device
  def return_device!(returned_at = Time.current)
    update!(
      status: 'returned',
      rented_until: returned_at.to_date
    )
  end

  # Mark as overdue
  def mark_overdue!
    update!(status: 'overdue') if active? && overdue?
  end

  private

  def device_must_be_available
    return unless device

    if device.rented?
      errors.add(:device, 'is already rented')
    elsif !device.available?
      errors.add(:device, 'is not available for rent')
    end
  end

  def rented_until_must_be_after_rented_from
    if rented_until <= rented_from
      errors.add(:rented_until, 'must be after rented from date')
    end
  end

  def update_device_status_to_rented
    device.update!(status: 'rented')
  end

  def update_device_status_on_return
    if saved_change_to_status? && status == 'returned'
      device.update!(status: 'available')
    end
  end
end
