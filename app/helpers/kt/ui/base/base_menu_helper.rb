# app/helpers/kt/ui/base/base_menu_helper.rb
module KT
  module UI
    module Base
      module BaseMenuHelper
      # ===============================
      # 🔹 SHARED MENU PATTERNS
      # ===============================

  # ✅ SRP: Generic menu wrapper
  def menu_wrapper(menu_class: "kt-menu", data_attrs: {}, &block)
    default_data = { "kt-menu": true }.merge(data_attrs)
    content_tag(:div, class: menu_class, data: default_data, &block)
  end

  # ✅ SRP: Generic menu item wrapper
  def menu_item_wrapper(item_class: "kt-menu-item", data_attrs: {}, &block)
    content_tag(:div, class: item_class, data: data_attrs, &block)
  end

  # ✅ SRP: Generic menu link
  def menu_link(href:, link_class: "kt-menu-link", &block)
    link_to(href, class: link_class, &block)
  end

  # ✅ SRP: Menu icon component
  def menu_icon(icon_class:, icon_wrapper_class: "kt-menu-icon")
    content_tag(:span, class: icon_wrapper_class) do
      content_tag(:i, "", class: icon_class)
    end
  end

  # ✅ SRP: Menu title component
  def menu_title(title:, title_class: "kt-menu-title")
    content_tag(:span, title, class: title_class)
  end

  # ✅ SRP: Menu arrow component
  def menu_arrow(arrow_class: "kt-menu-arrow")
    content_tag(:span, class: arrow_class) do
      content_tag(:i, "", class: "ki-filled ki-right text-xs rtl:transform rtl:rotate-180")
    end
  end

  # ✅ SRP: Menu badge component
  def menu_badge(badge_text:, badge_class: "kt-menu-badge")
    content_tag(:span, class: badge_class) do
      content_tag(:span, badge_text, class: "kt-badge kt-badge-sm")
    end
  end

  # ✅ SRP: Menu separator
  def menu_separator(separator_class: "kt-menu-separator")
    content_tag(:div, "", class: separator_class)
  end

  # ✅ SRP: Menu dropdown container
  def menu_dropdown(dropdown_class: "kt-menu-dropdown", &block)
    content_tag(:div, class: dropdown_class, &block)
  end

  # ✅ SRP: Menu accordion container
  def menu_accordion(accordion_class: "kt-menu-accordion", &block)
    content_tag(:div, class: accordion_class, &block)
    end
  end
end
end
end
