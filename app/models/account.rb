class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_one :person, dependent: :destroy
  has_many :account_roles, dependent: :destroy
  # has_many :roles, through: :account_roles
  has_many :roles, through: :account_roles, after_remove: :inactive_employee_status!  
  has_many :roles, through: :account_roles, after_remove: :inactive_customer_status!  


  # Polymorphic association for issues
  has_many :assigned_issues, class_name: "Issue", foreign_key: :assigned_to_id

  # Issue assignments (many-to-many with issues)
  has_many :issue_assignments, dependent: :destroy
  has_many :assigned_issues_through_assignments, through: :issue_assignments, source: :issue

  has_many :issue_comments


  accepts_nested_attributes_for :person
  accepts_nested_attributes_for :issue_assignments, allow_destroy: true


  delegate :name, to: :person, prefix: true, allow_nil: true

  after_create :create_blank_person
  after_create_commit :assign_initial_roles  # ← gunakan after_create_commit agar aman setelah transaksi commit

def is_administrator?
    has_role?(:administrator)
  end

  def is_employee?
    has_role?(:employee) || is_administrator?
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

  private


  def is_customer?
    has_role?(:customer) || is_employee? || is_administrator?
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
      roles << customer_role unless has_role?(:customer)

      # Cek apakah ini akun pertama dalam sistem (gunakan query langsung ke DB)
      if Account.count == 1
        administrator_role = Role.find_or_create_by!(name: "administrator")
        employee_role = Role.find_or_create_by!(name: "employee")

        roles << administrator_role unless has_role?(:administrator)
        roles << employee_role unless has_role?(:employee)
      end
    end
  end

   # 🔹 Helper-role
  def has_role?(role_name)
    roles.exists?(name: role_name.to_s)
  end

  def add_role(role_name)
    role = Role.find_or_create_by(name: role_name.to_s)
    roles << role unless roles.include?(role)
  end

  def remove_role(role_name)
    role = roles.find_by(name: role_name.to_s)
    roles.delete(role) if role.present?
  end

  

end
