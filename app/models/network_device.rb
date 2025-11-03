class NetworkDevice < ApplicationRecord
  belongs_to :network
  belongs_to :device
  belongs_to :device_interface, optional: true
  has_many :network_activities, dependent: :destroy

  validates :network_id, presence: true
  validates :device_id, presence: true
  validates :status, inclusion: { in: %w[connected disconnected] }
  validates :network_id, uniqueness: { scope: :device_id }

  enum :status, {
    connected: "connected",
    disconnected: "disconnected"
  }

  # Scopes
  scope :connected, -> { where(status: 'connected') }
  scope :disconnected, -> { where(status: 'disconnected') }

  # Callbacks
  after_create :set_connected_at
  after_update :update_timestamps_on_status_change, if: :saved_change_to_status?

  private

  def set_connected_at
    update_column(:connected_at, Time.current) if connected?
  end

  def update_timestamps_on_status_change
    if saved_change_to_status?
      if connected?
        update_column(:connected_at, Time.current)
        update_column(:disconnected_at, nil)
      elsif disconnected?
        update_column(:disconnected_at, Time.current)
      end
    end
  end
end