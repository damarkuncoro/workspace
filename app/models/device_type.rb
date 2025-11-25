class DeviceType < ApplicationRecord
  has_many :devices, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
  
  def schema
    self[:schema] || {}
  end

  # Scope for active device types
  scope :active, -> { where.not(name: nil) }

end
