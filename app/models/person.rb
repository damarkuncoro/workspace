class Person < ApplicationRecord
  belongs_to :account
  has_one :customer, dependent: :destroy
  has_one :employee, dependent: :destroy

  # Phone associations
  has_many :person_phones, dependent: :destroy
  has_many :phones, through: :person_phones

  validates :name, presence: true,          on: :update
  validates :date_of_birth, presence: true, on: :update

  after_create_commit :assign_initial_customer

  def person_email
    account.email if account.present?
  end

  def incomplete?
    name.blank? || date_of_birth.blank?
  end

  private

  def assign_initial_customer
  # Pastikan customer dibuat
    create_customer! unless customer.present?
  end

end
