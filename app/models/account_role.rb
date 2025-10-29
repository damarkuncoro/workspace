class AccountRole < ApplicationRecord
  belongs_to :account
  belongs_to :role

  after_commit :set_active_employee_status!,  on: [:create]
  after_commit :set_active_customer_status!,  on: [:create]
  

  private

  def set_active_employee_status!
    account.active_employee_status!
  end
  def set_active_customer_status!
    account.active_customer_status!
  end

end
