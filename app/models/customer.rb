# frozen_string_literal: true

class Customer < ApplicationRecord
  belongs_to :person
  has_one :account, through: :person

  # Polymorphic association for issues
  has_many :issues, as: :issueable

  # Validasi dasar
  validates :status, presence: true, inclusion: { in: %w[active inactive] }
  validates :customer_code, presence: true, uniqueness: true

  # Scope helper
  scope :active,   -> { where(status: "active") }
  scope :inactive, -> { where(status: "inactive") }

  # Callback untuk data awal
  before_validation :assign_code,        on: :create
  before_validation :set_default_status, on: :create

  delegate :email, to: :account, prefix: true, allow_nil: true
  delegate :name, to: :person, prefix: true, allow_nil: true

  private

  # Default status = active
  def set_default_status
    self.status ||= "active"
  end

  # Generator kode unik customer
  def generate_code
    "CUST-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(3).upcase}"
  end

  def assign_code
    self.customer_code ||= generate_code
  end
end
