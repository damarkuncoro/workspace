class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_one :person, dependent: :destroy
  has_many :account_roles, dependent: :destroy
  has_many :roles, through: :account_roles


  # Polymorphic association for issues
  has_many :assigned_issues, class_name: "Issue", foreign_key: :assigned_to_id

  # Issue assignments (many-to-many with issues)
  has_many :issue_assignments, dependent: :destroy
  has_many :assigned_issues_through_assignments, through: :issue_assignments, source: :issue

  has_many :issue_comments

  # Role requests
  has_many :role_requests, foreign_key: :account_id
  has_many :requested_role_requests, foreign_key: :requested_by_id, class_name: 'RoleRequest'

  accepts_nested_attributes_for :person
  accepts_nested_attributes_for :issue_assignments, allow_destroy: true


  delegate :name, to: :person, prefix: true, allow_nil: true

  after_create_commit :create_blank_person
  after_create_commit :assign_initial_roles  # ← gunakan after_create_commit agar aman setelah transaksi commit

def is_administrator?
    has_role?(:administrator)
  end

  def is_employee?
    has_role?(:employee) || is_administrator?
  end


  def is_customer?
    has_role?(:customer) || is_employee? || is_administrator?
  end


def inactive_employee_status!(_role = nil)
  return unless person&.employee
  person.employee.update_column(:status, "inactive")
end

def inactive_customer_status!(_role = nil)
  return unless person&.customer
  person.customer.update_column(:status, "inactive")
end

  def active_customer_status!
    return unless person&.customer
    person.customer.update_column(:status, "active")
  end

  def active_employee_status!
    return unless person&.employee
    person.employee.update_column(:status, "active")
  end

  


  def add_role(role_name, assigned_by = nil)
    role = Role.find_or_create_by(name: role_name.to_s)
    return if has_role?(role_name)

    # Auto-create employee record if assigning employee role and doesn't exist
    if role_name.to_s == 'employee' && person.present? && person.employee.blank?
      person.create_employee!
    end

    account_roles.create!(
      role: role,
      created_by: assigned_by,
      assigned_at: Time.current
    )
  end

  def remove_role(role_name, revoked_by = nil)
    account_role = account_roles.active.joins(:role).find_by(roles: { name: role_name.to_s })
    account_role&.revoke!(revoked_by)
  end

  private

  def create_blank_person
    # Pastikan person selalu ada walau kosong
    create_person! if person.blank?
  end

  # 🔹 Assign role otomatis setelah akun dibuat
  def assign_initial_roles
    # Pakai transaction block untuk mencegah race condition
    AccountRole.transaction do
      customer_role = Role.find_or_create_by!(name: "customer")
      add_role("customer", self) unless has_role?(:customer)

      # Cek apakah ini akun pertama dalam sistem - force assign administrator role
      if Account.count == 1
        administrator_role = Role.find_or_create_by!(name: "administrator")
        employee_role = Role.find_or_create_by!(name: "employee")

        # Force assign administrator and employee roles to first account
        add_role("administrator", self)
        add_role("employee", self)
      end
    end
  end

  # 🔹 Helper-role
  def has_role?(role_name)
    account_roles.active.joins(:role).exists?(roles: { name: role_name.to_s })
  end

end
