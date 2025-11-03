class LinkConnection < ApplicationRecord
  # Relationships
  belongs_to :device_interface_a, class_name: 'DeviceInterface', foreign_key: 'device_interface_a_id'
  belongs_to :device_interface_b, class_name: 'DeviceInterface', foreign_key: 'device_interface_b_id'
  belongs_to :network, optional: true

  # Validations
  validates :device_interface_a_id, presence: true
  validates :device_interface_b_id, presence: true
  validates :link_type, presence: true
  validates :status, presence: true

  # Custom validation to prevent self-connections and duplicate connections
  validate :interfaces_must_be_different
  validate :connection_must_be_unique

  # Enums
  enum :link_type, {
    ethernet: "ethernet",
    fiber: "fiber",
    wireless: "wireless",
    vpn: "vpn",
    serial: "serial",
    usb: "usb",
    bluetooth: "bluetooth"
  }

  enum :status, {
    up: "up",
    down: "down",
    testing: "testing",
    error: "error",
    maintenance: "maintenance"
  }

  # Scopes
  scope :active, -> { where(status: [:up, :testing]) }
  scope :by_link_type, ->(link_type) { where(link_type: link_type) }
  scope :by_status, ->(status) { where(status: status) }
  scope :for_network, ->(network_id) { where(network_id: network_id) }

  # Instance methods
  def device_a
    device_interface_a&.device
  end

  def device_b
    device_interface_b&.device
  end

  def connection_name
    "#{device_a&.label || 'Unknown'} ↔ #{device_b&.label || 'Unknown'}"
  end

  # Class method untuk menemukan jalur koneksi antara dua device
  def self.find_connection_path(start_device_id, end_device_id, max_depth = 10)
    return [] if start_device_id == end_device_id

    visited = Set.new
    queue = [[start_device_id, []]] # [current_device_id, path_so_far]

    while queue.any? && visited.size < max_depth
      current_device_id, path = queue.shift

      next if visited.include?(current_device_id)
      visited.add(current_device_id)

      # Cari semua koneksi dari device saat ini
      connections = where(
        "device_interface_a_id IN (SELECT id FROM device_interfaces WHERE device_id = ?) OR
         device_interface_b_id IN (SELECT id FROM device_interfaces WHERE device_id = ?)",
        current_device_id, current_device_id
      ).where(status: [:up, :testing])

      connections.each do |connection|
        next_device_id = if connection.device_interface_a.device_id == current_device_id
                          connection.device_interface_b.device_id
                        else
                          connection.device_interface_a.device_id
                        end

        next if visited.include?(next_device_id)

        new_path = path + [connection]

        # Jika menemukan device tujuan, return path
        return new_path if next_device_id == end_device_id

        # Tambahkan ke queue untuk traversal selanjutnya
        queue.push([next_device_id, new_path])
      end
    end

    [] # Tidak menemukan jalur
  end

  # Instance method untuk mendapatkan semua device yang terhubung melalui path traversal
  def self.get_connected_devices(device_id, max_depth = 5)
    visited = Set.new
    queue = [device_id]
    connected_devices = Set.new

    while queue.any? && visited.size < max_depth
      current_device_id = queue.shift

      next if visited.include?(current_device_id)
      visited.add(current_device_id)

      # Cari semua koneksi dari device saat ini
      connections = where(
        "device_interface_a_id IN (SELECT id FROM device_interfaces WHERE device_id = ?) OR
         device_interface_b_id IN (SELECT id FROM device_interfaces WHERE device_id = ?)",
        current_device_id, current_device_id
      ).where(status: [:up, :testing])

      connections.each do |connection|
        next_device_id = if connection.device_interface_a.device_id == current_device_id
                          connection.device_interface_b.device_id
                        else
                          connection.device_interface_a.device_id
                        end

        unless visited.include?(next_device_id)
          connected_devices.add(next_device_id)
          queue.push(next_device_id)
        end
      end
    end

    connected_devices.to_a
  end

  def bandwidth_display
    return "N/A" unless bandwidth_mbps.present?
    "#{bandwidth_mbps} Mbps"
  end

  def latency_display
    return "N/A" unless latency_ms.present?
    "#{latency_ms} ms"
  end

  def status_color
    case status
    when 'up' then 'green'
    when 'down' then 'red'
    when 'testing' then 'yellow'
    when 'error' then 'red'
    when 'maintenance' then 'gray'
    else 'gray'
    end
  end

  def active?
    up? || testing?
  end

  private

  def interfaces_must_be_different
    if device_interface_a_id == device_interface_b_id
      errors.add(:device_interface_b_id, "cannot connect an interface to itself")
    end
  end

  def connection_must_be_unique
    # Check for existing connection in either direction
    existing_connection = LinkConnection.where(
      "(device_interface_a_id = ? AND device_interface_b_id = ?) OR (device_interface_a_id = ? AND device_interface_b_id = ?)",
      device_interface_a_id, device_interface_b_id, device_interface_b_id, device_interface_a_id
    ).where.not(id: id).exists?

    if existing_connection
      errors.add(:base, "A connection between these interfaces already exists")
    end
  end
end