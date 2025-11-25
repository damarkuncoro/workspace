class Device < ApplicationRecord
  belongs_to :device_type
  has_many :customer_devices, dependent: :restrict_with_error
  has_many :customers, through: :customer_devices

  # Add has_one association for current customer
  has_one :current_customer_device, -> { where(status: 'active') },
          class_name: 'CustomerDevice'
  has_one :current_customer, through: :current_customer_device, source: :customer

  # Network monitoring associations
  has_many :device_interfaces, dependent: :destroy
  has_many :network_devices, dependent: :destroy
  has_many :network_activities, dependent: :destroy
  has_many :networks, through: :network_devices

  validates :label, presence: true
  validates :serial_number, presence: true, uniqueness: true
  validates :status, presence: true
  validates :device_type, presence: true

  # Define enum - try with _prefix or _suffix option
  enum :status, {
    available: 0,
    rented: 1,
    maintenance: 2,
    retired: 3
  }

  def configuration_schema
    device_type&.schema || {}
  end

  def valid_configuration?(data)
    schema = configuration_schema
    return true if schema.blank? || data.blank?

    begin
      data = data.is_a?(String) ? JSON.parse(data) : data
    rescue JSON::ParserError
      return false
    end

    required = Array(schema['required'])
    properties = schema['properties'] || {}

    # Check required keys
    required.each do |key|
      return false unless data.key?(key)
    end

    # Basic type check based on properties
    data.each do |key, value|
      next unless properties[key]
      expected_type = properties[key]['type']
      next unless expected_type

      case expected_type
      when 'string'
        return false unless value.is_a?(String)
      when 'number'
        return false unless value.is_a?(Numeric)
      when 'integer'
        return false unless value.is_a?(Integer)
      when 'boolean'
        return false unless value == true || value == false
      when 'object'
        return false unless value.is_a?(Hash)
      when 'array'
        return false unless value.is_a?(Array)
      end
    end

    true
  end
end
