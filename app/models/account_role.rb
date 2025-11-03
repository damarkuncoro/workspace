class AccountRole < ApplicationRecord
  belongs_to :account
  belongs_to :role

  # Audit trail associations
  belongs_to :created_by, class_name: 'Account', optional: true
  belongs_to :revoked_by, class_name: 'Account', optional: true

  # Scopes for active/inactive roles
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  # Soft delete methods
  def revoke!(revoked_by_account = nil)
    update!(
      active: false,
      revoked_at: Time.current,
      revoked_by: revoked_by_account
    )
  end

  def assign!(assigned_by_account = nil)
    update!(
      active: true,
      assigned_at: Time.current,
      revoked_at: nil,
      revoked_by: nil,
      created_by: assigned_by_account
    )
  end

  after_commit :set_active_employee_status!,  on: [ :create ]
  after_commit :set_active_customer_status!,  on: [ :create ]


  private

  def set_active_employee_status!
    account.active_employee_status!
  end
  def set_active_customer_status!
    account.active_customer_status!
  end
end
