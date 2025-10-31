# app/helpers/kt/ui/base/base_dropdown_helper.rb
module KT
  module UI
    module Base
      module BaseDropdownHelper
      # ===============================
      # 🔹 SHARED DROPDOWN PATTERNS
      # ===============================

  # ✅ SRP: Generic dropdown wrapper with configurable attributes
  def dropdown_wrapper(attributes: {}, &block)
    default_attrs = {
      "kt-dropdown": true,
      "kt-dropdown-offset": "10px, 10px",
      "kt-dropdown-offset-rtl": "-10px, 10px",
      "kt-dropdown-placement": "bottom-end",
      "kt-dropdown-placement-rtl": "bottom-start"
    }
    merged_attrs = default_attrs.merge(attributes)

    content_tag(:div, class: "relative", data: merged_attrs, &block)
  end

  # ✅ SRP: Generic dropdown menu container
  def dropdown_menu_container(menu_class: "kt-dropdown-menu", &block)
    content_tag(:div, class: menu_class, data: { "kt-dropdown-menu": true }, &block)
  end

  # ✅ SRP: Generic dropdown trigger button
  def dropdown_trigger_button(icon:, button_class: "kt-btn kt-btn-ghost kt-btn-icon size-9 rounded-full hover:bg-primary/10 hover:[&_i]:text-primary", &block)
    button_tag(class: button_class, data: { "kt-dropdown-toggle": true }) do
      if block_given?
        capture(&block)
      else
        content_tag(:i, "", class: "ki-filled #{icon} text-lg")
        end
      end
    end
  end

  # ✅ SRP: Generic dropdown header section
  def dropdown_header_section(title:, subtitle: nil, header_class: "flex items-center justify-between gap-2.5 text-xs text-secondary-foreground font-medium px-5 py-3 border-b border-b-border")
    content_tag(:div, class: header_class) do
      concat content_tag(:span, title)
      concat content_tag(:span, subtitle) if subtitle
    end
  end

  # ✅ SRP: Generic dropdown list section
  def dropdown_list_section(items:, list_class: "flex flex-col kt-scrollable-y-auto max-h-[400px] divide-y divide-border", &block)
    content_tag(:div, class: list_class) do
      if block_given?
        capture(&block)
      else
        safe_join(items.map { |item| item.respond_to?(:call) ? item.call : item })
      end
    end
  end

  # ✅ SRP: Generic dropdown footer section
  def dropdown_footer_section(content:, footer_class: "grid p-5 border-t border-t-border")
    content_tag(:div, class: footer_class) do
      content
    end
  end
    end
  end
end
