class RoleRequest < ApplicationRecord
  belongs_to :role
  belongs_to :account
  belongs_to :requested_by, class_name: 'Account'
  belongs_to :approved_by, class_name: 'Account', optional: true

  # Validations
  validates :status, presence: true, inclusion: { in: %w[pending approved rejected cancelled] }
  validates :comment, length: { maximum: 1000 }

  # Scopes
  scope :pending, -> { where(status: 'pending') }
  scope :approved, -> { where(status: 'approved') }
  scope :rejected, -> { where(status: 'rejected') }
  scope :cancelled, -> { where(status: 'cancelled') }
  scope :for_account, ->(account) { where(account: account) }
  scope :by_requester, ->(requester) { where(requested_by: requester) }

  # Callbacks
  before_validation :set_requested_at, on: :create

  # Instance methods
  def approve!(approver)
    update!(
      status: 'approved',
      approved_at: Time.current,
      approved_by: approver
    )
  end

  def reject!(approver)
    update!(
      status: 'rejected',
      approved_at: Time.current,
      approved_by: approver
    )
  end

  def cancel!
    update!(status: 'cancelled')
  end

  def pending?
    status == 'pending'
  end

  def approved?
    status == 'approved'
  end

  def rejected?
    status == 'rejected'
  end

  def cancelled?
    status == 'cancelled'
  end

  private

  def set_requested_at
    self.requested_at ||= Time.current
  end
end
