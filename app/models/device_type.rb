class DeviceType < ApplicationRecord
  has_many :devices, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
  

  # Scope for active device types
  scope :active, -> { where.not(name: nil) }

end
