class Person < ApplicationRecord
  belongs_to :account
  has_one :customer, dependent: :destroy
  has_one :employee, dependent: :destroy

  validates :name, presence: true
  validates :date_of_birth, presence: true

  after_create_commit :assign_initial_customer_and_employee

  def person_email
    account.email if account.present?
  end

  def incomplete?
    name.blank? || date_of_birth.blank?
  end

  private

def assign_initial_customer_and_employee
  # Pastikan customer dibuat
  create_customer! unless customer.present?

  # Pastikan employee dibuat
  begin
    create_employee! unless employee.present?
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Gagal membuat employee: #{e.message}"
  end
end
end
