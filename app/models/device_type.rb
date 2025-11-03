class DeviceType < ApplicationRecord
  has_many :devices, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
  validates :schema, presence: true

  # Scope for active device types
  scope :active, -> { where.not(name: nil) }

  # Default schemas for common device types
  DEFAULT_SCHEMAS = {
    'Router' => {
      'type' => 'object',
      'properties' => {
        'brand' => { 'type' => 'string', 'description' => 'Router brand (e.g., Cisco, TP-Link)' },
        'model' => { 'type' => 'string', 'description' => 'Router model number' },
        'firmware_version' => { 'type' => 'string', 'description' => 'Current firmware version' },
        'wan_ports' => { 'type' => 'integer', 'description' => 'Number of WAN ports' },
        'lan_ports' => { 'type' => 'integer', 'description' => 'Number of LAN ports' },
        'wireless_standard' => { 'type' => 'string', 'description' => 'WiFi standard (e.g., 802.11ac, 802.11ax)' },
        'frequency_bands' => { 'type' => 'string', 'description' => 'Frequency bands (e.g., 2.4GHz, 5GHz)' },
        'max_speed' => { 'type' => 'string', 'description' => 'Maximum wireless speed' },
        'security_features' => { 'type' => 'string', 'description' => 'Security features (WPA3, Firewall, etc.)' }
      },
      'required' => ['brand', 'model']
    },
    'Laptop' => {
      'type' => 'object',
      'properties' => {
        'brand' => { 'type' => 'string', 'description' => 'Laptop brand (e.g., Dell, HP, Lenovo)' },
        'model' => { 'type' => 'string', 'description' => 'Laptop model' },
        'processor' => { 'type' => 'string', 'description' => 'Processor type and speed' },
        'ram' => { 'type' => 'string', 'description' => 'RAM capacity (e.g., 16GB DDR4)' },
        'storage' => { 'type' => 'string', 'description' => 'Storage type and capacity (e.g., 512GB SSD)' },
        'screen_size' => { 'type' => 'string', 'description' => 'Screen size in inches' },
        'operating_system' => { 'type' => 'string', 'description' => 'Installed operating system' },
        'battery_life' => { 'type' => 'string', 'description' => 'Battery life in hours' },
        'weight' => { 'type' => 'string', 'description' => 'Weight in kg' }
      },
      'required' => ['brand', 'model', 'processor', 'ram']
    },
    'Desktop Computer' => {
      'type' => 'object',
      'properties' => {
        'brand' => { 'type' => 'string', 'description' => 'Computer brand' },
        'model' => { 'type' => 'string', 'description' => 'Computer model' },
        'processor' => { 'type' => 'string', 'description' => 'Processor type and speed' },
        'ram' => { 'type' => 'string', 'description' => 'RAM capacity' },
        'storage' => { 'type' => 'string', 'description' => 'Storage configuration' },
        'graphics_card' => { 'type' => 'string', 'description' => 'Graphics card model' },
        'operating_system' => { 'type' => 'string', 'description' => 'Installed operating system' },
        'power_supply' => { 'type' => 'string', 'description' => 'Power supply wattage' },
        'case_type' => { 'type' => 'string', 'description' => 'Case form factor' }
      },
      'required' => ['brand', 'model', 'processor', 'ram']
    },
    'Tablet' => {
      'type' => 'object',
      'properties' => {
        'brand' => { 'type' => 'string', 'description' => 'Tablet brand (e.g., Apple, Samsung)' },
        'model' => { 'type' => 'string', 'description' => 'Tablet model' },
        'screen_size' => { 'type' => 'string', 'description' => 'Screen size in inches' },
        'storage' => { 'type' => 'string', 'description' => 'Storage capacity' },
        'operating_system' => { 'type' => 'string', 'description' => 'Operating system' },
        'cellular_capability' => { 'type' => 'boolean', 'description' => 'Has cellular connectivity' },
        'battery_life' => { 'type' => 'string', 'description' => 'Battery life' },
        'accessories' => { 'type' => 'string', 'description' => 'Included accessories' }
      },
      'required' => ['brand', 'model', 'screen_size']
    },
    'Smartphone' => {
      'type' => 'object',
      'properties' => {
        'brand' => { 'type' => 'string', 'description' => 'Phone brand (e.g., Apple, Samsung)' },
        'model' => { 'type' => 'string', 'description' => 'Phone model' },
        'screen_size' => { 'type' => 'string', 'description' => 'Screen size in inches' },
        'storage' => { 'type' => 'string', 'description' => 'Storage capacity' },
        'operating_system' => { 'type' => 'string', 'description' => 'Operating system and version' },
        'camera_specs' => { 'type' => 'string', 'description' => 'Camera specifications' },
        'battery_capacity' => { 'type' => 'string', 'description' => 'Battery capacity in mAh' },
        'network_support' => { 'type' => 'string', 'description' => 'Network support (5G, 4G, etc.)' }
      },
      'required' => ['brand', 'model', 'operating_system']
    },
    'Printer' => {
      'type' => 'object',
      'properties' => {
        'brand' => { 'type' => 'string', 'description' => 'Printer brand' },
        'model' => { 'type' => 'string', 'description' => 'Printer model' },
        'type' => { 'type' => 'string', 'description' => 'Printer type (Laser, Inkjet, etc.)' },
        'connectivity' => { 'type' => 'string', 'description' => 'Connectivity options (USB, WiFi, Ethernet)' },
        'print_speed' => { 'type' => 'string', 'description' => 'Print speed specifications' },
        'resolution' => { 'type' => 'string', 'description' => 'Print resolution (DPI)' },
        'paper_capacity' => { 'type' => 'string', 'description' => 'Paper tray capacity' },
        'duplex_printing' => { 'type' => 'boolean', 'description' => 'Supports double-sided printing' }
      },
      'required' => ['brand', 'model', 'type']
    },
    'Monitor' => {
      'type' => 'object',
      'properties' => {
        'brand' => { 'type' => 'string', 'description' => 'Monitor brand' },
        'model' => { 'type' => 'string', 'description' => 'Monitor model' },
        'screen_size' => { 'type' => 'string', 'description' => 'Screen size in inches' },
        'resolution' => { 'type' => 'string', 'description' => 'Native resolution' },
        'panel_type' => { 'type' => 'string', 'description' => 'Panel technology (IPS, TN, VA)' },
        'refresh_rate' => { 'type' => 'string', 'description' => 'Refresh rate in Hz' },
        'connectors' => { 'type' => 'string', 'description' => 'Available connectors (HDMI, DisplayPort, etc.)' },
        'brightness' => { 'type' => 'string', 'description' => 'Brightness in nits' }
      },
      'required' => ['brand', 'model', 'screen_size', 'resolution']
    },
    'Server' => {
      'type' => 'object',
      'properties' => {
        'brand' => { 'type' => 'string', 'description' => 'Server brand' },
        'model' => { 'type' => 'string', 'description' => 'Server model' },
        'processor' => { 'type' => 'string', 'description' => 'Processor specifications' },
        'ram' => { 'type' => 'string', 'description' => 'RAM configuration' },
        'storage' => { 'type' => 'string', 'description' => 'Storage configuration' },
        'raid_support' => { 'type' => 'string', 'description' => 'RAID support level' },
        'network_interfaces' => { 'type' => 'string', 'description' => 'Network interface specifications' },
        'power_consumption' => { 'type' => 'string', 'description' => 'Power consumption specifications' },
        'rack_units' => { 'type' => 'integer', 'description' => 'Rack unit size' }
      },
      'required' => ['brand', 'model', 'processor', 'ram']
    }
  }

  # Get default schema for a device type
  def self.default_schema_for(name)
    DEFAULT_SCHEMAS[name] || DEFAULT_SCHEMAS['Router']
  end

  # Validate JSON schema format
  validate :schema_must_be_valid_json

  private

  def schema_must_be_valid_json
    return if schema.blank?

    begin
      JSON.parse(schema.to_json) if schema.is_a?(Hash)
    rescue JSON::ParserError
      errors.add(:schema, 'must be valid JSON')
    end
  end
end
