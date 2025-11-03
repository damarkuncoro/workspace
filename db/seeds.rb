# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create default roles
%w[customer employee administrator].each do |r|
  Role.find_or_create_by!(name: r)
end
puts "✅ Default roles created"

# Create device types (no schema column in database)
device_types_data = [
  { name: "Laptop", description: "Portable computers for office and development work" },
  { name: "Desktop Computer", description: "Stationary computers for office and workstation use" },
  { name: "Router", description: "Network routers for internet connectivity" },
  { name: "Tablet", description: "Portable tablet devices for mobile computing" },
  { name: "Smartphone", description: "Mobile phones with advanced computing capabilities" },
  { name: "Printer", description: "Printing devices for document reproduction" },
  { name: "Monitor", description: "Display devices for computer output" },
  { name: "Server", description: "Server computers for data processing and hosting" }
]

device_types_data.each do |device_type_data|
  device_type = DeviceType.find_or_create_by!(name: device_type_data[:name]) do |dt|
    dt.description = device_type_data[:description]
  end
  puts "✅ Device type '#{device_type.name}' created/updated"
end

# Create sample devices for each device type
device_types = DeviceType.all

# Sample devices data (matching schema: device_type_id, label, serial_number, model, firmware_version, status)
sample_devices = [
  # Laptops
  { device_type: "Laptop", label: "MacBook Pro 16-inch M1", serial_number: "MBP16M1-001", model: "MacBook Pro 16-inch", firmware_version: "12.3.1" },
  { device_type: "Laptop", label: "Dell XPS 13", serial_number: "DXPS13-001", model: "XPS 13 9310", firmware_version: "1.2.3" },
  { device_type: "Laptop", label: "Lenovo ThinkPad X1 Carbon", serial_number: "TPX1C-001", model: "ThinkPad X1 Carbon Gen 9", firmware_version: "1.15" },

  # Desktop Computers
  { device_type: "Desktop Computer", label: "Dell OptiPlex 7080", serial_number: "DOP7080-001", model: "OptiPlex 7080", firmware_version: "1.2.1" },
  { device_type: "Desktop Computer", label: "HP EliteDesk 800 G5", serial_number: "HED800G5-001", model: "EliteDesk 800 G5", firmware_version: "02.04.00" },

  # Routers
  { device_type: "Router", label: "Cisco RV340", serial_number: "CRV340-001", model: "RV340", firmware_version: "1.0.3.22" },
  { device_type: "Router", label: "TP-Link Archer C80", serial_number: "TPAC80-001", model: "Archer C80", firmware_version: "1.11.2" },

  # Tablets
  { device_type: "Tablet", label: "iPad Pro 12.9-inch", serial_number: "IPP129-001", model: "iPad Pro 12.9-inch (5th gen)", firmware_version: "15.3.1" },
  { device_type: "Tablet", label: "Samsung Galaxy Tab S8", serial_number: "SGTS8-001", model: "Galaxy Tab S8", firmware_version: "12.0" },

  # Smartphones
  { device_type: "Smartphone", label: "iPhone 14 Pro", serial_number: "IP14P-001", model: "iPhone 14 Pro", firmware_version: "16.2" },
  { device_type: "Smartphone", label: "Samsung Galaxy S22", serial_number: "SGS22-001", model: "Galaxy S22", firmware_version: "S901BXXS3BVD2" },

  # Printers
  { device_type: "Printer", label: "HP LaserJet Pro M182nw", serial_number: "HPLJM182-001", model: "LaserJet Pro M182nw", firmware_version: "20221014" },
  { device_type: "Printer", label: "Epson EcoTank ET-8550", serial_number: "EEET8550-001", model: "EcoTank ET-8550", firmware_version: "1.0.1" },

  # Monitors
  { device_type: "Monitor", label: "Dell UltraSharp U2720Q", serial_number: "DU2720Q-001", model: "UltraSharp U2720Q", firmware_version: "M2T102" },
  { device_type: "Monitor", label: "LG 27UK650-W", serial_number: "LG27UK650-001", model: "27UK650-W", firmware_version: "04.02.25" },

  # Servers
  { device_type: "Server", label: "Dell PowerEdge R440", serial_number: "DPR440-001", model: "PowerEdge R440", firmware_version: "2.10.10" },
  { device_type: "Server", label: "HP ProLiant DL380 Gen10", serial_number: "HPDL380G10-001", model: "ProLiant DL380 Gen10", firmware_version: "2.70" }
]

sample_devices.each do |device_data|
  device_type = DeviceType.find_by(name: device_data[:device_type])
  next unless device_type

  device = Device.find_or_create_by!(serial_number: device_data[:serial_number]) do |d|
    d.device_type = device_type
    d.label = device_data[:label]
    d.model = device_data[:model]
    d.firmware_version = device_data[:firmware_version]
    d.status = 0 # available (enum default)
  end
  puts "✅ Device '#{device.label}' (#{device.serial_number}) created/updated"
end

# Create sample networks
puts "🌐 Creating sample networks..."
networks_data = [
  {
    name: "Corporate LAN",
    kind: "lan",
    cidr: "10.0.1.0/24",
    location: "Headquarters - Main Building",
    metadata: {
      "vlan_id" => 100,
      "dhcp_range" => "10.0.1.10-10.0.1.250",
      "gateway" => "10.0.1.1",
      "dns_servers" => ["10.0.1.2", "8.8.8.8"],
      "subnet_mask" => "255.255.255.0"
    }
  },
  {
    name: "Guest WiFi Network",
    kind: "wifi",
    cidr: "192.168.10.0/24",
    location: "Lobby & Conference Rooms",
    metadata: {
      "ssid" => "CorporateGuest",
      "security" => "WPA3-Enterprise",
      "bandwidth_limit" => "5Mbps per client",
      "dhcp_range" => "192.168.10.50-192.168.10.200",
      "frequency" => "2.4GHz & 5GHz",
      "max_clients" => 50
    }
  },
  {
    name: "Development Environment",
    kind: "lan",
    cidr: "172.16.0.0/16",
    location: "Development Lab",
    metadata: {
      "vlan_id" => 200,
      "dhcp_enabled" => false,
      "static_ips_only" => true,
      "network_purpose" => "Development and Testing",
      "monitoring" => "Advanced SNMP"
    }
  },
  {
    name: "Remote Access VPN",
    kind: "vpn",
    cidr: "10.10.0.0/16",
    location: "Global Remote Access",
    metadata: {
      "vpn_type" => "IPsec/IKEv2",
      "authentication" => "Multi-factor",
      "max_connections" => 200,
      "split_tunneling" => true,
      "geo_restriction" => "Allowed countries only"
    }
  },
  {
    name: "DMZ Network",
    kind: "lan",
    cidr: "192.168.100.0/24",
    location: "Data Center DMZ",
    metadata: {
      "security_level" => "High",
      "firewall_rules" => "Strict inbound/outbound",
      "monitoring" => "24/7 SIEM",
      "purpose" => "Public-facing services"
    }
  },
  {
    name: "IoT Network",
    kind: "wifi",
    cidr: "192.168.50.0/24",
    location: "Smart Building Systems",
    metadata: {
      "device_types" => ["Sensors", "Cameras", "HVAC", "Lighting"],
      "security" => "WPA2 with MAC filtering",
      "bandwidth_allocation" => "Low priority",
      "monitoring" => "Basic health checks"
    }
  }
]

networks_data.each do |network_data|
  network = Network.find_or_create_by!(name: network_data[:name]) do |n|
    n.kind = network_data[:kind]
    n.cidr = network_data[:cidr]
    n.location = network_data[:location]
    n.metadata = network_data[:metadata]
  end
  puts "✅ Network '#{network.name}' created/updated"
end

# Create device interfaces for existing devices
puts "🔌 Creating device interfaces..."
devices = Device.all
interface_templates = {
  "Laptop" => [
    { name: "Ethernet", link_type: "ethernet", speed: "1Gbps" },
    { name: "Wi-Fi", link_type: "wifi", speed: "866Mbps" }
  ],
  "Desktop Computer" => [
    { name: "eth0", link_type: "ethernet", speed: "1Gbps" },
    { name: "eth1", link_type: "ethernet", speed: "1Gbps" }
  ],
  "Server" => [
    { name: "eno1", link_type: "ethernet", speed: "10Gbps" },
    { name: "eno2", link_type: "ethernet", speed: "10Gbps" },
    { name: "eno3", link_type: "ethernet", speed: "10Gbps" },
    { name: "eno4", link_type: "ethernet", speed: "10Gbps" }
  ],
  "Router" => [
    { name: "GigabitEthernet0/0", link_type: "ethernet", speed: "1Gbps" },
    { name: "GigabitEthernet0/1", link_type: "ethernet", speed: "1Gbps" },
    { name: "Wireless0", link_type: "wifi", speed: "1300Mbps" }
  ],
  "Tablet" => [
    { name: "Wi-Fi", link_type: "wifi", speed: "866Mbps" },
    { name: "Cellular", link_type: "virtual", speed: "100Mbps" }
  ],
  "Smartphone" => [
    { name: "Wi-Fi", link_type: "wifi", speed: "866Mbps" },
    { name: "Cellular", link_type: "virtual", speed: "100Mbps" }
  ],
  "Printer" => [
    { name: "Ethernet", link_type: "ethernet", speed: "1Gbps" },
    { name: "Wi-Fi", link_type: "wifi", speed: "72Mbps" }
  ],
  "Monitor" => [
    { name: "HDMI", link_type: "virtual", speed: "18Gbps" },
    { name: "DisplayPort", link_type: "virtual", speed: "32Gbps" }
  ]
}

devices.each do |device|
  device_type_name = device.device_type.name
  templates = interface_templates[device_type_name] || [{ name: "eth0", link_type: "ethernet", speed: "1Gbps" }]

  templates.each do |template|
    mac_address = "02:#{rand(256).to_s(16).rjust(2,'0')}:#{rand(256).to_s(16).rjust(2,'0')}:#{rand(256).to_s(16).rjust(2,'0')}:#{rand(256).to_s(16).rjust(2,'0')}:#{rand(256).to_s(16).rjust(2,'0')}"

    # Ensure unique MAC addresses
    while DeviceInterface.exists?(mac: mac_address)
      mac_address = "02:#{rand(256).to_s(16).rjust(2,'0')}:#{rand(256).to_s(16).rjust(2,'0')}:#{rand(256).to_s(16).rjust(2,'0')}:#{rand(256).to_s(16).rjust(2,'0')}:#{rand(256).to_s(16).rjust(2,'0')}"
    end

    device_interface = DeviceInterface.find_or_create_by!(device: device, mac: mac_address) do |di|
      di.name = template[:name]
      di.link_type = template[:link_type]
      di.metadata = {
        "speed" => template[:speed],
        "duplex" => ["full", "half"].sample,
        "status" => "up",
        "mtu" => [1500, 9000].sample,
        "driver" => case template[:link_type]
                    when "ethernet" then ["e1000e", "igb", "ixgbe"].sample
                    when "wifi" then ["iwlwifi", "ath9k", "rt2800pci"].sample
                    else "generic"
                    end
      }
    end

    puts "✅ Device interface '#{device_interface.name}' created for #{device.label}"
  end
end

# Create network-device connections
puts "🔗 Creating network device connections..."
networks = Network.all
device_interfaces = DeviceInterface.all

# Strategic connections based on device types and network purposes
connection_rules = {
  "Corporate LAN" => ["Laptop", "Desktop Computer", "Printer"],
  "Guest WiFi Network" => ["Laptop", "Tablet", "Smartphone"],
  "Development Environment" => ["Laptop", "Desktop Computer", "Server"],
  "Remote Access VPN" => ["Laptop", "Desktop Computer"],
  "DMZ Network" => ["Server", "Router"],
  "IoT Network" => ["Router"] # IoT devices would have their own interfaces
}

device_interfaces.each do |device_interface|
  device_type_name = device_interface.device.device_type.name

  # Determine which networks this device type should connect to
  eligible_networks = networks.select do |network|
    connection_rules[network.name]&.include?(device_type_name) ||
    (network.name == "Corporate LAN" && ["Laptop", "Desktop Computer", "Server", "Printer", "Router"].include?(device_type_name))
  end

  # Connect to 1-3 eligible networks
  num_connections = [eligible_networks.size, rand(1..3)].min
  connected_networks = eligible_networks.sample(num_connections)

  connected_networks.each do |network|
    # Generate IP address within network CIDR
    ip_address = case network.name
                 when "Corporate LAN"
                   "10.0.1.#{rand(10..250)}"
                 when "Guest WiFi Network"
                   "192.168.10.#{rand(50..200)}"
                 when "Development Environment"
                   "172.16.#{rand(0..255)}.#{rand(1..254)}"
                 when "Remote Access VPN"
                   "10.10.#{rand(0..255)}.#{rand(1..254)}"
                 when "DMZ Network"
                   "192.168.100.#{rand(10..250)}"
                 when "IoT Network"
                   "192.168.50.#{rand(10..250)}"
                 else
                   "192.168.#{rand(1..255)}.#{rand(1..254)}"
                 end

    # Ensure unique IP addresses per network
    while NetworkDevice.exists?(network: network, ip_address: IPAddr.new(ip_address))
      ip_address = case network.name
                   when "Corporate LAN"
                     "10.0.1.#{rand(10..250)}"
                   when "Guest WiFi Network"
                     "192.168.10.#{rand(50..200)}"
                   when "Development Environment"
                     "172.16.#{rand(0..255)}.#{rand(1..254)}"
                   when "Remote Access VPN"
                     "10.10.#{rand(0..255)}.#{rand(1..254)}"
                   when "DMZ Network"
                     "192.168.100.#{rand(10..250)}"
                   when "IoT Network"
                     "192.168.50.#{rand(10..250)}"
                   else
                     "192.168.#{rand(1..255)}.#{rand(1..254)}"
                   end
    end

    status = ["connected", "disconnected"].sample

    network_device = NetworkDevice.find_or_create_by!(network: network, device: device_interface.device) do |nd|
      nd.device_interface = device_interface
      nd.ip_address = IPAddr.new(ip_address)
      nd.status = status
      nd.metadata = {
        "connection_type" => device_interface.link_type,
        "bandwidth_used" => "#{rand(1..100)}%",
        "last_seen" => rand(1..30).days.ago.iso8601,
        "connection_quality" => case device_interface.link_type
                                when "wifi" then ["Excellent", "Good", "Fair", "Poor"].sample
                                when "ethernet" then "Excellent"
                                else "Good"
                                end,
        "data_transferred" => "#{rand(1..1000)} GB"
      }

      # Set timestamps based on status
      if status == "connected"
        nd.connected_at = rand(30.days.ago..Time.current)
      else
        nd.connected_at = rand(60.days.ago..30.days.ago)
        nd.disconnected_at = rand(30.days.ago..Time.current)
      end
    end

    puts "✅ Network connection: #{device_interface.device.label} ↔ #{network.name} (#{status})"
  end
end

# Create network activities
puts "📊 Creating network activities..."
network_devices = NetworkDevice.all
event_types = ["dhcp_assigned", "link_up", "link_down", "ip_change", "auth_fail", "rssi"]

# Create activities for each network device
network_devices.each do |network_device|
  # Create 5-15 activities per network device
  num_activities = rand(5..15)

  num_activities.times do |i|
    event_type = event_types.sample
    recorded_at = rand(30.days.ago..Time.current)

    # Generate appropriate data based on event type
    data = case event_type
           when "dhcp_assigned"
             {
               "ip_address" => network_device.ip_address.to_s,
               "lease_time" => "#{rand(1..24)} hours",
               "hostname" => network_device.device.label.parameterize,
               "dhcp_server" => case network_device.network.name
                                 when "Corporate LAN" then "10.0.1.2"
                                 when "Guest WiFi Network" then "192.168.10.1"
                                 else "192.168.1.1"
                                 end
             }
           when "link_up"
             {
               "interface" => network_device.device_interface&.name,
               "speed" => network_device.device_interface&.metadata&.dig("speed") || "1Gbps",
               "duplex" => ["full", "half"].sample,
               "link_type" => network_device.device_interface&.link_type
             }
           when "link_down"
             {
               "interface" => network_device.device_interface&.name,
               "reason" => ["cable disconnected", "interface disabled", "power loss", "configuration change"].sample,
               "duration" => "#{rand(1..3600)} seconds",
               "auto_recovery" => [true, false].sample
             }
           when "ip_change"
             old_ip_parts = network_device.ip_address.to_s.split('.')
             old_ip_parts[3] = (old_ip_parts[3].to_i - 1).to_s
             {
               "old_ip" => old_ip_parts.join('.'),
               "new_ip" => network_device.ip_address.to_s,
               "reason" => ["DHCP renewal", "manual change", "network reconfiguration"].sample,
               "initiated_by" => ["dhcp_client", "administrator", "system"].sample
             }
           when "auth_fail"
             {
               "attempts" => rand(1..10),
               "reason" => ["wrong password", "certificate expired", "account locked", "brute force"].sample,
               "source_ip" => network_device.ip_address.to_s,
               "user_agent" => ["Mozilla/5.0", "curl/7.68.0", "PostmanRuntime"].sample,
               "blocked" => [true, false].sample
             }
           when "rssi"
             {
               "signal_strength" => "#{rand(-90..-30)} dBm",
               "frequency" => ["2.4GHz", "5GHz", "6GHz"].sample,
               "channel" => rand(1..177),
               "noise_floor" => "#{rand(-100..-80)} dBm",
               "snr" => "#{rand(10..40)} dB"
             }
           # Removed dhcp_renewal, dns_query, and port_scan cases as they're not valid event types
           end

    network_activity = NetworkActivity.find_or_create_by!(
      network: network_device.network,
      device: network_device.device,
      device_interface: network_device.device_interface,
      event_type: event_type,
      recorded_at: recorded_at
    ) do |na|
      na.data = data
    end

    puts "✅ Network activity '#{event_type}' recorded for #{network_device.device.label}"
  end
end

# Create link connections between device interfaces
puts "🔗 Creating link connections between device interfaces..."

# Get all devices and their interfaces for consistent linking
devices = Device.includes(:device_interfaces).all
device_interfaces = DeviceInterface.includes(:device).all
networks = Network.all

# Create strategic connections between devices with consistent interface naming
link_connections_data = [
  # Corporate LAN connections - Router to workstations
  {
    device_a_label: "Cisco RV340",
    interface_a_name: "GigabitEthernet0/1",
    device_b_label: "MacBook Pro 16-inch M1",
    interface_b_name: "eth0",
    network_name: "Corporate LAN",
    link_type: "ethernet",
    status: "up",
    bandwidth_mbps: 1000,
    latency_ms: 0.5,
    metadata: {
      "cable_type" => "CAT6",
      "cable_id" => "LAN-001",
      "patch_panel" => "PP-A1",
      "switch_port" => "01",
      "device_port" => "eth0",
      "length_meters" => 5
    }
  },
  {
    device_a_label: "Cisco RV340",
    interface_a_name: "GigabitEthernet0/2",
    device_b_label: "Dell XPS 13",
    interface_b_name: "eth0",
    network_name: "Corporate LAN",
    link_type: "ethernet",
    status: "up",
    bandwidth_mbps: 1000,
    latency_ms: 0.5,
    metadata: {
      "cable_type" => "CAT6",
      "cable_id" => "LAN-002",
      "patch_panel" => "PP-A1",
      "switch_port" => "02",
      "device_port" => "eth0",
      "length_meters" => 8
    }
  },
  {
    device_a_label: "Cisco RV340",
    interface_a_name: "GigabitEthernet0/3",
    device_b_label: "HP EliteDesk 800 G5",
    interface_b_name: "eth0",
    network_name: "Corporate LAN",
    link_type: "ethernet",
    status: "up",
    bandwidth_mbps: 1000,
    latency_ms: 0.5,
    metadata: {
      "cable_type" => "CAT6",
      "cable_id" => "LAN-003",
      "patch_panel" => "PP-A1",
      "switch_port" => "03",
      "device_port" => "eth0",
      "length_meters" => 12
    }
  },

  # Server connections to router
  {
    device_a_label: "Cisco RV340",
    interface_a_name: "GigabitEthernet0/10",
    device_b_label: "Dell PowerEdge R440",
    interface_b_name: "eth0",
    network_name: "Corporate LAN",
    link_type: "ethernet",
    status: "up",
    bandwidth_mbps: 1000,
    latency_ms: 0.3,
    metadata: {
      "cable_type" => "CAT6A",
      "cable_id" => "SRV-001",
      "patch_panel" => "PP-S1",
      "switch_port" => "10",
      "device_port" => "eth0",
      "length_meters" => 15
    }
  },
  {
    device_a_label: "Cisco RV340",
    interface_a_name: "GigabitEthernet0/11",
    device_b_label: "HP ProLiant DL380 Gen10",
    interface_b_name: "eth0",
    network_name: "Corporate LAN",
    link_type: "ethernet",
    status: "up",
    bandwidth_mbps: 1000,
    latency_ms: 0.3,
    metadata: {
      "cable_type" => "CAT6A",
      "cable_id" => "SRV-002",
      "patch_panel" => "PP-S1",
      "switch_port" => "11",
      "device_port" => "eth0",
      "length_meters" => 18
    }
  },

  # Wireless connections - Access point to mobile devices
  {
    device_a_label: "TP-Link Archer C80",
    interface_a_name: "wlan0-2g",
    device_b_label: "iPhone 14 Pro",
    interface_b_name: "wlan0",
    network_name: "Guest WiFi Network",
    link_type: "wireless",
    status: "up",
    bandwidth_mbps: 150,
    latency_ms: 5.2,
    metadata: {
      "frequency" => "2.4GHz",
      "channel" => 6,
      "signal_strength" => "-45dBm",
      "encryption" => "WPA3",
      "ssid" => "GuestWiFi"
    }
  },
  {
    device_a_label: "TP-Link Archer C80",
    interface_a_name: "wlan0-5g",
    device_b_label: "Samsung Galaxy S22",
    interface_b_name: "wlan0",
    network_name: "Guest WiFi Network",
    link_type: "wireless",
    status: "up",
    bandwidth_mbps: 300,
    latency_ms: 3.8,
    metadata: {
      "frequency" => "5GHz",
      "channel" => 36,
      "signal_strength" => "-38dBm",
      "encryption" => "WPA3",
      "ssid" => "GuestWiFi-5G"
    }
  },

  # Printer connections
  {
    device_a_label: "Cisco RV340",
    interface_a_name: "GigabitEthernet0/20",
    device_b_label: "HP LaserJet Pro M182nw",
    interface_b_name: "eth0",
    network_name: "Corporate LAN",
    link_type: "ethernet",
    status: "up",
    bandwidth_mbps: 100,
    latency_ms: 1.2,
    metadata: {
      "cable_type" => "CAT5e",
      "cable_id" => "PRT-001",
      "patch_panel" => "PP-P1",
      "switch_port" => "20",
      "device_port" => "eth0",
      "length_meters" => 25
    }
  },

  # High-speed fiber connection between servers
  {
    device_a_label: "Dell PowerEdge R440",
    interface_a_name: "eth1",
    device_b_label: "HP ProLiant DL380 Gen10",
    interface_b_name: "eth1",
    network_name: "Corporate LAN",
    link_type: "ethernet",
    status: "up",
    bandwidth_mbps: 10000,
    latency_ms: 0.1,
    metadata: {
      "fiber_type" => "OM3",
      "cable_id" => "FIB-001",
      "connector_type" => "LC-LC",
      "length_meters" => 50,
      "wavelength" => "850nm",
      "mode" => "multimode"
    }
  },

  # VPN connections
  {
    device_a_label: "Cisco RV340",
    interface_a_name: "tun0",
    device_b_label: "MacBook Pro 16-inch M1",
    interface_b_name: "tun0",
    network_name: "Remote Access VPN",
    link_type: "vpn",
    status: "up",
    bandwidth_mbps: 50,
    latency_ms: 25.5,
    metadata: {
      "vpn_type" => "OpenVPN",
      "encryption" => "AES-256-GCM",
      "protocol" => "UDP",
      "mtu" => 1450,
      "remote_ip" => "203.0.113.1"
    }
  },

  # Problematic connections for testing
  {
    device_a_label: "Cisco RV340",
    interface_a_name: "GigabitEthernet0/4",
    device_b_label: "Lenovo ThinkPad X1 Carbon",
    interface_b_name: "eth0",
    network_name: "Corporate LAN",
    link_type: "ethernet",
    status: "down",
    bandwidth_mbps: 0,
    latency_ms: nil,
    metadata: {
      "cable_type" => "CAT6",
      "cable_id" => "LAN-004",
      "issue" => "Cable damaged at connector",
      "last_seen" => 2.days.ago.iso8601,
      "troubleshooting_notes" => "Cable tested bad, needs replacement"
    }
  },

  # Display connections (non-network)
  {
    device_a_label: "HP EliteDesk 800 G5",
    interface_a_name: "HDMI1",
    device_b_label: "Dell UltraSharp U2720Q",
    interface_b_name: "HDMI1",
    network_name: nil,
    link_type: "serial",
    status: "error",
    bandwidth_mbps: nil,
    latency_ms: nil,
    metadata: {
      "cable_type" => "HDMI 2.0",
      "cable_id" => "MON-001",
      "resolution" => "3840x2160",
      "refresh_rate" => "60Hz",
      "issue" => "EDID handshake failed",
      "hdcp_version" => "2.2"
    }
  },

  # Additional wireless connections
  {
    device_a_label: "TP-Link Archer C80",
    interface_a_name: "wlan0-2g",
    device_b_label: "iPad Pro 12.9-inch",
    interface_b_name: "wlan0",
    network_name: "Guest WiFi Network",
    link_type: "wireless",
    status: "up",
    bandwidth_mbps: 100,
    latency_ms: 8.5,
    metadata: {
      "frequency" => "2.4GHz",
      "channel" => 6,
      "signal_strength" => "-52dBm",
      "encryption" => "WPA3",
      "ssid" => "GuestWiFi"
    }
  },

  # Bluetooth connection example
  {
    device_a_label: "MacBook Pro 16-inch M1",
    interface_a_name: "bluetooth0",
    device_b_label: "iPhone 14 Pro",
    interface_b_name: "bluetooth0",
    network_name: nil,
    link_type: "bluetooth",
    status: "up",
    bandwidth_mbps: 2,
    latency_ms: 15.0,
    metadata: {
      "bluetooth_version" => "5.0",
      "profile" => "A2DP",
      "paired_devices" => ["iPhone 14 Pro"],
      "connection_quality" => "excellent"
    }
  }
]

# Create ISP/Core Network Topology
puts "🌐 Creating ISP/Core Network Topology..."

# Add new devices for ISP infrastructure
isp_devices_data = [
  # Core Router (ISP Level)
  {
    device_type: "Router",
    label: "Juniper MX960 Core Router",
    serial_number: "JMX960-001",
    model: "MX960",
    firmware_version: "20.4R3-S4",
    status: 0
  },
  # Distribution Router
  {
    device_type: "Router",
    label: "Cisco ASR 9000 Distribution",
    serial_number: "CASR9000-001",
    model: "ASR-9006-DC",
    firmware_version: "7.5.2",
    status: 0
  },
  # Access Router/ONU
  {
    device_type: "Router",
    label: "Huawei MA5800 ONU",
    serial_number: "HMA5800-001",
    model: "MA5800-X17",
    firmware_version: "V100R019C10SPC607",
    status: 0
  },
  # Customer Premises Equipment
  {
    device_type: "Router",
    label: "TP-Link Archer VR600",
    serial_number: "TPAVR600-001",
    model: "Archer VR600",
    firmware_version: "0.9.1 1.1 v009c.0 Build 200221 Rel.56287n",
    status: 0
  }
]

isp_devices_data.each do |device_data|
  device_type = DeviceType.find_by(name: device_data[:device_type])
  next unless device_type

  device = Device.find_or_create_by!(serial_number: device_data[:serial_number]) do |d|
    d.device_type = device_type
    d.label = device_data[:label]
    d.model = device_data[:model]
    d.firmware_version = device_data[:firmware_version]
    d.status = device_data[:status]
  end
  puts "✅ ISP Device '#{device.label}' created/updated"
end

# Create interfaces for ISP devices
isp_devices = Device.where(label: ["Juniper MX960 Core Router", "Cisco ASR 9000 Distribution", "Huawei MA5800 ONU", "TP-Link Archer VR600"])

isp_devices.each do |device|
  case device.label
  when "Juniper MX960 Core Router"
    # Core router interfaces
    interfaces = [
      { name: "xe-0/0/0", link_type: "ethernet", speed: "100Gbps" },
      { name: "xe-0/0/1", link_type: "ethernet", speed: "100Gbps" },
      { name: "et-0/0/0", link_type: "ethernet", speed: "400Gbps" }
    ]
  when "Cisco ASR 9000 Distribution"
    interfaces = [
      { name: "HundredGigE0/0/0/0", link_type: "ethernet", speed: "100Gbps" },
      { name: "HundredGigE0/0/0/1", link_type: "ethernet", speed: "100Gbps" },
      { name: "TenGigE0/0/0/0", link_type: "ethernet", speed: "10Gbps" },
      { name: "TenGigE0/0/0/1", link_type: "ethernet", speed: "10Gbps" }
    ]
  when "Huawei MA5800 ONU"
    interfaces = [
      { name: "GPON0/1/0", link_type: "ethernet", speed: "2.5Gbps" },
      { name: "GPON0/1/1", link_type: "ethernet", speed: "2.5Gbps" },
      { name: "GE0/1/0", link_type: "ethernet", speed: "1Gbps" },
      { name: "GE0/1/1", link_type: "ethernet", speed: "1Gbps" }
    ]
  when "TP-Link Archer VR600"
    interfaces = [
      { name: "Internet", link_type: "ethernet", speed: "1Gbps" },
      { name: "LAN1", link_type: "ethernet", speed: "1Gbps" },
      { name: "LAN2", link_type: "ethernet", speed: "1Gbps" },
      { name: "LAN3", link_type: "ethernet", speed: "1Gbps" },
      { name: "LAN4", link_type: "ethernet", speed: "1Gbps" },
      { name: "Wireless_2.4G", link_type: "wifi", speed: "300Mbps" },
      { name: "Wireless_5G", link_type: "wifi", speed: "867Mbps" }
    ]
  end

  interfaces.each do |interface_template|
    mac_address = "02:#{rand(256).to_s(16).rjust(2,'0')}:#{rand(256).to_s(16).rjust(2,'0')}:#{rand(256).to_s(16).rjust(2,'0')}:#{rand(256).to_s(16).rjust(2,'0')}:#{rand(256).to_s(16).rjust(2,'0')}"

    while DeviceInterface.exists?(mac: mac_address)
      mac_address = "02:#{rand(256).to_s(16).rjust(2,'0')}:#{rand(256).to_s(16).rjust(2,'0')}:#{rand(256).to_s(16).rjust(2,'0')}:#{rand(256).to_s(16).rjust(2,'0')}:#{rand(256).to_s(16).rjust(2,'0')}"
    end

    device_interface = DeviceInterface.find_or_create_by!(device: device, mac: mac_address) do |di|
      di.name = interface_template[:name]
      di.link_type = interface_template[:link_type]
      di.metadata = {
        "speed" => interface_template[:speed],
        "duplex" => ["full", "half"].sample,
        "status" => "up",
        "mtu" => [1500, 9000, 9216].sample,
        "driver" => case interface_template[:link_type]
                    when "ethernet" then ["ixgbe", "i40e", "mlx5_core"].sample
                    when "fiber" then ["mlx5_core", "qede"].sample
                    when "wifi" then ["ath9k", "iwlwifi"].sample
                    else "generic"
                    end
      }
    end

    puts "✅ ISP Interface '#{device_interface.name}' created for #{device.label}"
  end
end

# Create ISP network topology connections
isp_link_connections_data = [
  # Core Router → Distribution Router
  {
    device_a_label: "Juniper MX960 Core Router",
    interface_a_name: "xe-0/0/0",
    device_b_label: "Cisco ASR 9000 Distribution",
    interface_b_name: "HundredGigE0/0/0/0",
    network_name: nil, # Backbone network
    link_type: "ethernet",
    status: "up",
    bandwidth_mbps: 100000, # 100 Gbps
    latency_ms: 0.05,
    metadata: {
      "fiber_type" => "OS2",
      "cable_id" => "BACKBONE-001",
      "distance_km" => 5,
      "wavelength" => "1550nm",
      "mode" => "singlemode",
      "connector_type" => "LC-LC",
      "isp_backbone" => true,
      "service_level" => "Platinum"
    }
  },
  # Distribution Router → Access ONU
  {
    device_a_label: "Cisco ASR 9000 Distribution",
    interface_a_name: "TenGigE0/0/0/0",
    device_b_label: "Huawei MA5800 ONU",
    interface_b_name: "GigabitEthernet0/0",
    network_name: nil,
    link_type: "ethernet",
    status: "up",
    bandwidth_mbps: 10000, # 10 Gbps
    latency_ms: 0.1,
    metadata: {
      "cable_type" => "CAT6A",
      "cable_id" => "DIST-001",
      "distance_m" => 2000,
      "connector_type" => "RJ45",
      "olt_port" => "GE0/1/0",
      "ont_serial" => "48575443F5A6C9D0"
    }
  },
  # Access ONU → Customer CPE
  {
    device_a_label: "Huawei MA5800 ONU",
    interface_a_name: "GE0/1/0",
    device_b_label: "TP-Link Archer VR600",
    interface_b_name: "Internet",
    network_name: nil,
    link_type: "ethernet",
    status: "up",
    bandwidth_mbps: 1000, # 1 Gbps
    latency_ms: 0.5,
    metadata: {
      "cable_type" => "CAT6",
      "cable_id" => "CPE-001",
      "distance_m" => 50,
      "patch_panel" => "PP-CPE-01",
      "switch_port" => "GE0/1/0",
      "device_port" => "Internet",
      "service_type" => "FTTH",
      "customer_id" => "CUST-001"
    }
  },
  # Customer CPE → Existing Corporate Router
  {
    device_a_label: "TP-Link Archer VR600",
    interface_a_name: "LAN1",
    device_b_label: "Cisco RV340",
    interface_b_name: "GigabitEthernet0/0",
    network_name: "Corporate LAN",
    link_type: "ethernet",
    status: "up",
    bandwidth_mbps: 1000,
    latency_ms: 0.3,
    metadata: {
      "cable_type" => "CAT6",
      "cable_id" => "LAN-EXT-001",
      "distance_m" => 10,
      "cpe_port" => "LAN1",
      "router_port" => "GigabitEthernet0/0",
      "vlan_id" => 100,
      "customer_network" => true
    }
  }
]

isp_link_connections_data.each do |connection_data|
  # Find the devices by label
  device_a = Device.find_by(label: connection_data[:device_a_label])
  device_b = Device.find_by(label: connection_data[:device_b_label])

  if device_a.nil? || device_b.nil?
    puts "⚠️  Skipping ISP link connection: Device not found (#{connection_data[:device_a_label]} or #{connection_data[:device_b_label]})"
    next
  end

  # Find the specific interfaces
  interface_a = device_a.device_interfaces.find_by(name: connection_data[:interface_a_name])
  interface_b = device_b.device_interfaces.find_by(name: connection_data[:interface_b_name])

  if interface_a.nil? || interface_b.nil?
    puts "⚠️  Skipping ISP link connection: Interface not found (#{connection_data[:interface_a_name]} on #{device_a.label} or #{connection_data[:interface_b_name]} on #{device_b.label})"
    next
  end

  # Find network if specified
  network = connection_data[:network_name].present? ? Network.find_by(name: connection_data[:network_name]) : nil

  # Create or update the link connection
  link_connection = LinkConnection.find_or_create_by!(
    device_interface_a_id: interface_a.id,
    device_interface_b_id: interface_b.id
  ) do |lc|
    lc.network = network
    lc.link_type = connection_data[:link_type]
    lc.status = connection_data[:status]
    lc.bandwidth_mbps = connection_data[:bandwidth_mbps]
    lc.latency_ms = connection_data[:latency_ms]
    lc.metadata = connection_data[:metadata]
  end

  puts "✅ ISP Link connection: #{device_a.label} (#{interface_a.name}) ↔ #{device_b.label} (#{interface_b.name}) [#{connection_data[:link_type]}, #{connection_data[:status]}]"
end

# Now process the original link connections
link_connections_data.each do |connection_data|
  # Find the devices by label
  device_a = Device.find_by(label: connection_data[:device_a_label])
  device_b = Device.find_by(label: connection_data[:device_b_label])

  if device_a.nil? || device_b.nil?
    puts "⚠️  Skipping link connection: Device not found (#{connection_data[:device_a_label]} or #{connection_data[:device_b_label]})"
    next
  end

  # Find the specific interfaces - try different naming patterns
  interface_a = device_a.device_interfaces.find_by(name: connection_data[:interface_a_name])

  # If not found, try alternative names for routers
  if interface_a.nil? && device_a.device_type.name == "Router"
    case connection_data[:interface_a_name]
    when "GigabitEthernet0/1" then interface_a = device_a.device_interfaces.find_by(name: "GigabitEthernet0/1")
    when "GigabitEthernet0/2" then interface_a = device_a.device_interfaces.find_by(name: "GigabitEthernet0/2")
    when "GigabitEthernet0/3" then interface_a = device_a.device_interfaces.find_by(name: "GigabitEthernet0/3")
    when "GigabitEthernet0/10" then interface_a = device_a.device_interfaces.find_by(name: "GigabitEthernet0/10")
    when "GigabitEthernet0/11" then interface_a = device_a.device_interfaces.find_by(name: "GigabitEthernet0/11")
    when "GigabitEthernet0/20" then interface_a = device_a.device_interfaces.find_by(name: "GigabitEthernet0/20")
    when "GigabitEthernet0/4" then interface_a = device_a.device_interfaces.find_by(name: "GigabitEthernet0/4")
    when "Wireless0" then interface_a = device_a.device_interfaces.find_by(name: "Wireless0")
    when "tun0" then interface_a = device_a.device_interfaces.find_by(name: "tun0")
    end
  end

  # For laptops/desktops, try "Ethernet" instead of "eth0"
  if interface_a.nil? && ["Laptop", "Desktop Computer"].include?(device_a.device_type.name) && connection_data[:interface_a_name] == "eth0"
    interface_a = device_a.device_interfaces.find_by(name: "Ethernet")
  end

  # For wireless connections, try "Wi-Fi" instead of "wlan0"
  if interface_a.nil? && connection_data[:interface_a_name] == "wlan0"
    interface_a = device_a.device_interfaces.find_by(name: "Wi-Fi")
  end

  # For access points, try "Wireless0" instead of "wlan0-2g" or "wlan0-5g"
  if interface_a.nil? && device_a.device_type.name == "Router" && ["wlan0-2g", "wlan0-5g"].include?(connection_data[:interface_a_name])
    interface_a = device_a.device_interfaces.find_by(name: "Wireless0")
  end

  # For printers, try "Ethernet" instead of "eth0"
  if interface_a.nil? && device_a.device_type.name == "Printer" && connection_data[:interface_a_name] == "eth0"
    interface_a = device_a.device_interfaces.find_by(name: "Ethernet")
  end

  # For servers, try "eno1" instead of "eth0" or "eth1"
  if interface_a.nil? && device_a.device_type.name == "Server"
    case connection_data[:interface_a_name]
    when "eth0" then interface_a = device_a.device_interfaces.find_by(name: "eno1")
    when "eth1" then interface_a = device_a.device_interfaces.find_by(name: "eno2")
    end
  end

  # For monitors, try "HDMI" instead of "HDMI1"
  if interface_a.nil? && device_a.device_type.name == "Monitor" && connection_data[:interface_a_name] == "HDMI1"
    interface_a = device_a.device_interfaces.find_by(name: "HDMI")
  end

  # Now do the same for device_b
  interface_b = device_b.device_interfaces.find_by(name: connection_data[:interface_b_name])

  # If not found, try alternative names for routers
  if interface_b.nil? && device_b.device_type.name == "Router"
    case connection_data[:interface_b_name]
    when "GigabitEthernet0/1" then interface_b = device_b.device_interfaces.find_by(name: "GigabitEthernet0/1")
    when "GigabitEthernet0/2" then interface_b = device_b.device_interfaces.find_by(name: "GigabitEthernet0/2")
    when "GigabitEthernet0/3" then interface_b = device_b.device_interfaces.find_by(name: "GigabitEthernet0/3")
    when "GigabitEthernet0/10" then interface_b = device_b.device_interfaces.find_by(name: "GigabitEthernet0/10")
    when "GigabitEthernet0/11" then interface_b = device_b.device_interfaces.find_by(name: "GigabitEthernet0/11")
    when "GigabitEthernet0/20" then interface_b = device_b.device_interfaces.find_by(name: "GigabitEthernet0/20")
    when "GigabitEthernet0/4" then interface_b = device_b.device_interfaces.find_by(name: "GigabitEthernet0/4")
    when "Wireless0" then interface_b = device_b.device_interfaces.find_by(name: "Wireless0")
    when "tun0" then interface_b = device_b.device_interfaces.find_by(name: "tun0")
    end
  end

  # For laptops/desktops, try "Ethernet" instead of "eth0"
  if interface_b.nil? && ["Laptop", "Desktop Computer"].include?(device_b.device_type.name) && connection_data[:interface_b_name] == "eth0"
    interface_b = device_b.device_interfaces.find_by(name: "Ethernet")
  end

  # For wireless connections, try "Wi-Fi" instead of "wlan0"
  if interface_b.nil? && connection_data[:interface_b_name] == "wlan0"
    interface_b = device_b.device_interfaces.find_by(name: "Wi-Fi")
  end

  # For access points, try "Wireless0" instead of "wlan0-2g" or "wlan0-5g"
  if interface_b.nil? && device_b.device_type.name == "Router" && ["wlan0-2g", "wlan0-5g"].include?(connection_data[:interface_b_name])
    interface_b = device_b.device_interfaces.find_by(name: "Wireless0")
  end

  # For printers, try "Ethernet" instead of "eth0"
  if interface_b.nil? && device_b.device_type.name == "Printer" && connection_data[:interface_b_name] == "eth0"
    interface_b = device_b.device_interfaces.find_by(name: "Ethernet")
  end

  # For servers, try "eno1" instead of "eth0" or "eth1"
  if interface_b.nil? && device_b.device_type.name == "Server"
    case connection_data[:interface_b_name]
    when "eth0" then interface_b = device_b.device_interfaces.find_by(name: "eno1")
    when "eth1" then interface_b = device_b.device_interfaces.find_by(name: "eno2")
    end
  end

  # For monitors, try "HDMI" instead of "HDMI1"
  if interface_b.nil? && device_b.device_type.name == "Monitor" && connection_data[:interface_b_name] == "HDMI1"
    interface_b = device_b.device_interfaces.find_by(name: "HDMI")
  end

  # For Bluetooth connections, try to find any interface
  if interface_b.nil? && connection_data[:interface_b_name] == "bluetooth0"
    # Bluetooth might not be created, skip this one
    puts "⚠️  Skipping Bluetooth link connection: Interface bluetooth0 not found on #{device_b.label}"
    next
  end

  if interface_a.nil? || interface_b.nil?
    puts "⚠️  Skipping link connection: Interface not found (#{connection_data[:interface_a_name]} on #{device_a.label} or #{connection_data[:interface_b_name]} on #{device_b.label})"
    next
  end

  # Find network if specified
  network = connection_data[:network_name].present? ? Network.find_by(name: connection_data[:network_name]) : nil

  # Create or update the link connection
  link_connection = LinkConnection.find_or_create_by!(
    device_interface_a_id: interface_a.id,
    device_interface_b_id: interface_b.id
  ) do |lc|
    lc.network = network
    lc.link_type = connection_data[:link_type]
    lc.status = connection_data[:status]
    lc.bandwidth_mbps = connection_data[:bandwidth_mbps]
    lc.latency_ms = connection_data[:latency_ms]
    lc.metadata = connection_data[:metadata]
  end

  puts "✅ Link connection: #{device_a.label} (#{interface_a.name}) ↔ #{device_b.label} (#{interface_b.name}) [#{connection_data[:link_type]}, #{connection_data[:status]}]"
end

puts "🎉 Database seeding completed successfully!"
puts "📊 Summary:"
puts "   • #{DeviceType.count} device types"
puts "   • #{Device.count} devices"
puts "   • #{Network.count} networks"
puts "   • #{DeviceInterface.count} device interfaces"
puts "   • #{NetworkDevice.count} network device connections"
puts "   • #{NetworkActivity.count} network activities"
puts "   • #{LinkConnection.count} link connections"