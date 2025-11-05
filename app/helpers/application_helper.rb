module ApplicationHelper
  include Pagy::Frontend

  # Fungsi: Merender tombol toggle sidebar secara reusable/DRY.
  # - Menggunakan default kelas/atribut yang selaras dengan KTUI/Metronic.
  # - Opsi dapat diberikan untuk override kelas tambahan atau target toggle.
  # Parameter:
  # - html_options: Hash opsional untuk menambah/override atribut HTML (misal: class, id)
  # Return: HTML Safe string tombol lengkap dengan ikon.
  def sidebar_toggle_button(html_options = {})
    default_button_classes = [
      "kt-btn",
      "kt-btn-outline",
      "kt-btn-icon",
      "size-[30px]",
      "absolute",
      "start-full",
      "top-2/4",
      "-translate-x-2/4",
      "-translate-y-2/4"
    ]

    icon_classes = [
      "ki-filled",
      "ki-black-left-line",
      "kt-toggle-active:rotate-180",
      "transition-all",
      "duration-300"
    ]

    # Atribut data default untuk integrasi toggle KTUI
    data_attrs = {
      "data-kt-toggle" => html_options.delete(:data_kt_toggle) || "body",
      "data-kt-toggle-class" => html_options.delete(:data_kt_toggle_class) || "kt-sidebar-collapse"
    }

    # ID default tombol
    button_id = html_options.delete(:id) || "sidebar_toggle"

    # Merge kelas dari pemanggil jika ada
    button_class = (html_options.delete(:class) || "").split
    final_button_classes = (default_button_classes + button_class).uniq.join(" ")

    # Bangun elemen ikon
    icon_tag = content_tag(:i, "", class: icon_classes.join(" "))

    # Bangun tombol
    content_tag(
      :button,
      icon_tag,
      {
        id: button_id,
        class: final_button_classes
      }.merge(data_attrs).merge(html_options)
    )
  end
  def full_page_title(title = nil)
    base_title = "CAKRAMEDIA"
    title.blank? ? base_title : "#{title} | #{base_title}"
  end

  def nav_active?(path)
    "active" if current_page?(path)
  end

  def status_badge(status)
    case status.downcase
    when "active", "completed", "success"
      "badge badge-success"
    when "pending", "in progress"
      "badge badge-warning"
    else
      "badge badge-secondary"
    end
  end

  def status_badge_class(status)
    case status
    when 'open'
      'bg-red-100 text-red-800'
    when 'in_progress'
      'bg-yellow-100 text-yellow-800'
    when 'completed'
      'bg-green-100 text-green-800'
    when 'closed'
      'bg-gray-100 text-gray-800'
    else
      'bg-gray-100 text-gray-800'
    end
  end

  def priority_badge_class(priority)
    case priority
    when 'high'
      'bg-red-100 text-red-800'
    when 'medium'
      'bg-yellow-100 text-yellow-800'
    when 'low'
      'bg-green-100 text-green-800'
    else
      'bg-blue-100 text-blue-800'
    end
  end
end
