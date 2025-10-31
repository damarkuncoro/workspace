# app/helpers/kt/components/sidebar_component.rb
module KT::Components::SidebarComponent
  include KT::UI::Base::BaseUIHelper
  include KT::UI::Base::BaseMenuHelper

  # ✅ SRP: Main sidebar component
  def ui_sidebar(items: [], variant: :default, collapsible: true, collapsed: false, **options)
    classes = build_sidebar_classes(variant: variant, collapsed: collapsed)
    data_attrs = collapsible ? { "kt-sidebar": true, "kt-sidebar-collapsed": collapsed } : {}

    content_tag(:aside, class: classes, data: data_attrs, **options) do
      concat sidebar_header if collapsible
      concat sidebar_menu(items)
      concat sidebar_footer if block_given?
    end
  end

  # ✅ SRP: Sidebar header with collapse toggle
  def sidebar_header
    content_tag(:div, class: "kt-sidebar-header flex items-center justify-between p-4 border-b border-border") do
      concat content_tag(:h2, "Menu", class: "text-lg font-semibold")
      concat sidebar_collapse_button
    end
  end

  # ✅ SRP: Collapse toggle button
  def sidebar_collapse_button
    button_tag(class: "kt-sidebar-toggle p-1 rounded hover:bg-accent", data: { "kt-sidebar-toggle": true }) do
      ui_icon(name: "chevron-left", size: :sm, wrapper_class: "kt-sidebar-toggle-icon")
    end
  end

  # ✅ SRP: Sidebar menu
  def sidebar_menu(items)
    content_tag(:nav, class: "kt-sidebar-menu flex-1 overflow-y-auto") do
      content_tag(:ul, class: "space-y-1 p-4") do
        safe_join(items.map { |item| sidebar_menu_item(item) })
      end
    end
  end

  # ✅ SRP: Individual sidebar menu item
  def sidebar_menu_item(item)
    content_tag(:li) do
      if item[:children]
        sidebar_menu_item_with_children(item)
      else
        sidebar_menu_item_simple(item)
      end
    end
  end

  # ✅ SRP: Simple menu item
  def sidebar_menu_item_simple(item)
    link_to(item[:href] || "#", class: "sidebar-menu-link flex items-center gap-3 px-3 py-2 rounded-md text-sm hover:bg-accent hover:text-accent-foreground transition-colors #{item[:active] ? 'bg-accent text-accent-foreground' : ''}") do
      concat ui_icon(name: item[:icon], size: :sm) if item[:icon]
      concat content_tag(:span, item[:text], class: "kt-sidebar-text")
      concat ui_badge(text: item[:badge], size: :xs) if item[:badge]
    end
  end

  # ✅ SRP: Menu item with children (accordion)
  def sidebar_menu_item_with_children(item)
    content_tag(:div, class: "kt-sidebar-accordion", data: { "kt-accordion": true }) do
      concat sidebar_accordion_trigger(item)
      concat sidebar_accordion_content(item[:children])
    end
  end

  # ✅ SRP: Accordion trigger
  def sidebar_accordion_trigger(item)
    button_tag(class: "sidebar-menu-link flex items-center justify-between w-full px-3 py-2 rounded-md text-sm hover:bg-accent hover:text-accent-foreground transition-colors", data: { "kt-accordion-toggle": true }) do
      concat content_tag(:div, class: "flex items-center gap-3") do
        concat ui_icon(name: item[:icon], size: :sm) if item[:icon]
        concat content_tag(:span, item[:text], class: "kt-sidebar-text")
      end
      concat ui_icon(name: "chevron-down", size: :xs, wrapper_class: "kt-accordion-icon transition-transform")
    end
  end

  # ✅ SRP: Accordion content
  def sidebar_accordion_content(children)
    content_tag(:div, class: "kt-accordion-content ml-6 mt-1 space-y-1", data: { "kt-accordion-content": true }) do
      safe_join(children.map do |child|
        link_to(child[:href] || "#", class: "sidebar-submenu-link flex items-center gap-3 px-3 py-2 rounded-md text-sm text-muted-foreground hover:bg-accent hover:text-accent-foreground transition-colors #{child[:active] ? 'bg-accent text-accent-foreground' : ''}") do
          concat ui_icon(name: child[:icon], size: :xs) if child[:icon]
          concat content_tag(:span, child[:text], class: "kt-sidebar-text")
        end
      end)
    end
  end

  # ✅ SRP: Sidebar footer
  def sidebar_footer(&block)
    content_tag(:div, class: "kt-sidebar-footer p-4 border-t border-border", &block)
  end

  private

  def build_sidebar_classes(variant:, collapsed:)
    variant_class = case variant
    when :compact then "w-16"
    when :standard then "w-64"
    when :wide then "w-80"
    else "w-64"
    end

    build_classes("kt-sidebar flex flex-col bg-background border-r border-border transition-all duration-300", variant_class, collapsed && "kt-sidebar-collapsed")
  end
end
