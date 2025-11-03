class Role < ApplicationRecord
  has_many :account_roles, dependent: :destroy
  has_many :accounts, through: :account_roles

  # Active accounts with this role
  has_many :active_account_roles, -> { active }, class_name: 'AccountRole'
  has_many :active_accounts, through: :active_account_roles, source: :account

  validates :name, presence: true, uniqueness: true
end
