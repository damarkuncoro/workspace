module ApplicationHelper
  include Pagy::Frontend

  # Include KT helpers agar tersedia di semua view
  # - Konten & layout: menyediakan `kt_content_container`, dll.
  include KT::ContentHelper
  # - Topbar user: menyediakan `kt_topbar_user` dan pendukungnya
  include KT::TopbarHelper
  # - Table dan elemen kt_* dinamis: menyediakan `kt_table`, `kt_table_col`, dll.
  include KT::TableHelper
  # - Button helper: menyediakan `kt_button`, `kt_submit_button`, dsb.
  include KT::ButtonHelper

  # Render flash messages menggunakan Tailwind utility classes.
  # Tujuan: menggantikan penggunaan <%= notice %> dan <%= alert %> di view
  # dengan komponen notifikasi konsisten yang mendukung berbagai tipe flash.
  # Simple, DRY, dan mudah dipakai di seluruh aplikasi.
  #
  # Contoh pemakaian di view/layout:
  #   <%= render_flash_messages %>
  #
  # Mendukung key: :notice, :alert, :error, :warning, :info.
  def render_flash_messages
    return "" if flash.empty?

    safe_join(
      flash.map do |key, message|
        next if message.blank?

        base_classes = [
          "mb-3",
          "rounded-md",
          "border",
          "p-3",
          "text-sm",
          "flex",
          "items-start",
          "gap-2"
        ]

        color_classes = case key.to_sym
                        when :notice
                          ["bg-green-50", "text-green-800", "border-green-200"]
                        when :alert, :error
                          ["bg-red-50", "text-red-800", "border-red-200"]
                        when :warning
                          ["bg-yellow-50", "text-yellow-800", "border-yellow-200"]
                        else # :info atau lainnya
                          ["bg-blue-50", "text-blue-800", "border-blue-200"]
                        end

        icon_name = case key.to_sym
                    when :notice then "ki-check-circle"
                    when :alert, :error then "ki-information-2"
                    when :warning then "ki-information-2"
                    else "ki-information-2"
                    end

        content_tag(:div, class: (base_classes + color_classes).join(" ")) do
          safe_join([
            content_tag(:span, class: "mt-0.5") { content_tag(:i, "", class: "ki-filled #{icon_name}") },
            content_tag(:div) do
              Array(message).map { |m| content_tag(:p, m) }.reduce(&:+)
            end
          ])
        end
      end.compact
    )
  end

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

  # Fungsi: Menghasilkan kelas CSS untuk badge status berbasis KT.
  # SRP: Hanya memetakan status -> kelas CSS.
  # Return: String kelas, contoh "kt-badge kt-badge-sm kt-badge-success".
  def status_badge_class(status)
    key = status.to_s.downcase
    variant = case key
              when 'open' then 'destructive'
              when 'in_progress' then 'warning'
              when 'completed' then 'success'
              when 'closed' then 'secondary'
              else 'mono'
              end
    "kt-badge kt-badge-sm kt-badge-#{variant}"
  end

  # Fungsi: Menghasilkan kelas CSS untuk badge prioritas berbasis KT.
  # SRP: Hanya memetakan prioritas -> kelas CSS.
  # Return: String kelas, contoh "kt-badge kt-badge-sm kt-badge-warning".
  def priority_badge_class(priority)
    key = priority.to_s.downcase
    variant = case key
              when 'high' then 'destructive'
              when 'medium' then 'warning'
              when 'low' then 'success'
              else 'info'
              end
    "kt-badge kt-badge-sm kt-badge-#{variant}"
  end
end
