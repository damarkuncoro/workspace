# app/helpers/kt/ui/base/base_ui_helper.rb
module KT
  module UI
    module Base
      module BaseUIHelper
      # ===============================
      # 🔹 SHARED UI PATTERNS
      # ===============================

      # ✅ SRP: Utility method for building CSS classes
      def build_classes(*args)
        args.flatten.compact.join(" ")
      end

  # ✅ SRP: Generic badge component
  def ui_badge(text:, type: :default, size: :sm, outline: true, badge_class: "kt-badge")
    content_tag(:span, text, class: build_classes(
      badge_class,
      "kt-badge-#{size}",
      "kt-badge-#{type}",
      outline && "kt-badge-outline"
    ))
  end

  # ✅ SRP: Generic button component
  def ui_button(text: nil, icon: nil, type: :primary, size: :default, variant: :solid, button_class: "kt-btn", **options)
    content = []
    content << content_tag(:i, "", class: "ki-filled #{icon}") if icon
    content << text if text

    button_tag(safe_join(content), class: build_classes(
      button_class,
      "kt-btn-#{type}",
      size != :default && "kt-btn-#{size}",
      variant != :solid && "kt-btn-#{variant}"
    ), **options)
  end

  # ✅ SRP: Generic avatar component
  def ui_avatar(src:, alt: "", size: "size-9", avatar_class: "kt-avatar", status: nil, status_class: "kt-avatar-status-online")
    content_tag(:div, class: build_classes(avatar_class, size)) do
      concat(content_tag(:div, image_tag(src, alt: alt), class: "kt-avatar-image"))
      if status
        concat(content_tag(:div, class: "kt-avatar-indicator -end-2 -bottom-2") do
          content_tag(:div, "", class: build_classes("kt-avatar-status", status_class, "size-2.5"))
        end)
      end
    end
  end
  end

  # ✅ SRP: Generic switch component
  def ui_switch(name:, checked: false, switch_class: "kt-switch", **options)
    check_box_tag(name, "1", checked, class: switch_class, **options)
  end

  # ✅ SRP: Generic progress bar
  def ui_progress(value:, max: 100, progress_class: "kt-progress", indicator_class: "kt-progress-indicator")
    content_tag(:div, class: progress_class) do
      content_tag(:div, "", class: indicator_class, style: "width: #{(value.to_f / max * 100).round}%")
    end
  end

  # ✅ SRP: Generic table component
  def ui_table(headers: [], rows: [], table_class: "kt-table")
    content_tag(:table, class: table_class) do
      concat(ui_table_head(headers)) if headers.any?
      concat(ui_table_body(rows)) if rows.any?
    end
  end

  # ✅ SRP: Table head
  def ui_table_head(headers)
    content_tag(:thead) do
      content_tag(:tr) do
        safe_join(headers.map { |h| content_tag(:th, h[:title] || h, class: h[:class]) })
      end
    end
  end

  # ✅ SRP: Table body
  def ui_table_body(rows)
    content_tag(:tbody) do
      safe_join(rows.map do |row|
        content_tag(:tr) do
          safe_join(row.map { |cell| content_tag(:td, cell) })
        end
      end)
    end
  end

  # ✅ SRP: Generic link component
  def ui_link(text:, href:, link_class: "kt-link", underlined: false, dashed: false)
    link_to(text, href, class: build_classes(
      link_class,
      underlined && "kt-link-underlined",
      dashed && "kt-link-dashed"
    ))
  end

  # ✅ SRP: Generic icon component
  def ui_icon(icon_class:, size: "text-lg", icon_wrapper_class: "")
    content_tag(:i, "", class: build_classes(icon_class, size, icon_wrapper_class.presence))
  end
    end
  end
end
