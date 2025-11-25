# frozen_string_literal: true

# CustomerDevicesHelper
# Tanggung jawab:
# - Menyediakan helper tampilan untuk halaman CustomerDevices (index/table)
# - Memformat label perangkat, informasi perangkat, periode rental, dan badge status
# - Mengurangi logika di view (SRP/DRY, KISS)
#
# Catatan:
# - Semua metode defensif terhadap nilai nil
# - Komentar level-fungsi disediakan sesuai permintaan
module CustomerDevicesHelper
  # Mengembalikan nama tampil perangkat.
  # Gunakan Device#label agar konsisten dan tidak memanggil atribut yang tidak ada.
  # Param: device [Device]
  # Return: [String]
  def device_label(device)
    device&.label.to_s
  end

  # Mengembalikan metadata perangkat berupa tipe dan serial number.
  # Format: "<device_type.name> • SN: <serial_number>"
  # Param: device [Device]
  # Return: [String]
  def device_meta(device)
    type_name = device&.device_type&.name.to_s
    serial = device&.serial_number.to_s
    return '' if type_name.empty? && serial.empty?
    [type_name.presence, (serial.present? ? "SN: #{serial}" : nil)].compact.join(' • ')
  end

  # Mengembalikan nama pelanggan.
  # Param: customer [Customer]
  # Return: [String]
  def customer_name(customer)
    customer&.person_name.to_s
  end

  # Mengembalikan email akun pelanggan.
  # Param: customer [Customer]
  # Return: [String]
  def customer_email(customer)
    customer&.account_email.to_s
  end

  # Mengembalikan label tanggal mulai rental.
  # Param: customer_device [CustomerDevice], format [String]
  # Return: [String]
  def rented_from_label(customer_device, format = '%b %d, %Y')
    date = customer_device&.rented_from
    date ? date.strftime(format) : ''
  end

  # Mengembalikan label tanggal selesai rental atau "Ongoing" jika belum di-set.
  # Param: customer_device [CustomerDevice], format [String]
  # Return: [String]
  def rented_until_label(customer_device, format = '%b %d, %Y')
    date = customer_device&.rented_until
    date ? "to #{date.strftime(format)}" : 'Ongoing'
  end

  # Merender badge status untuk baris rental.
  # Warna:
  # - overdue? -> merah
  # - active?  -> hijau
  # - default  -> abu-abu, status.titleize
  # Param: customer_device [CustomerDevice]
  # Return: [String] (HTML-safe)
  def status_tag(customer_device)
    if customer_device&.overdue?
      content_tag(:span, 'Overdue', class: 'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800')
    elsif customer_device&.active?
      content_tag(:span, 'Active', class: 'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800')
    else
      text = customer_device&.status.to_s.titleize
      content_tag(:span, text, class: 'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800')
    end
  end
end

