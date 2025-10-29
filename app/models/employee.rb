class Employee < ApplicationRecord
  belongs_to :person
  has_one :account, through: :person

  # Polymorphic association for issues
  has_many :issues, as: :issueable

  validates :employee_code, presence: true, allow_nil: true
  validates :status, presence: true, allow_nil: true
  validates :status, inclusion: { in: %w[active inactive] }

  # Scope helper
  scope :active,   -> { where(status: 'active') }
  scope :inactive, -> { where(status: 'inactive') }

  # Callback untuk data awal
  before_validation :assign_code,        on: :create
  before_validation :set_default_status, on: :create


  delegate :email, to: :account, prefix: true, allow_nil: true
  delegate :name, to: :person, prefix: true, allow_nil: true

private

  # Default status = active
  def set_default_status
    self.status ||= 'inactive'
  end

  # Generator kode unik employee
  def generate_code
    "EMPL-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(3).upcase}"
  end

  def assign_code
    self.employee_code ||= generate_code
  end

end