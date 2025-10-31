# app/helpers/kt/components/navbar_component.rb
module KT::Components::NavbarComponent
  include KT::BaseUiHelper
  include KT::BaseMenuHelper

  # ✅ SRP: Main navbar component
  def ui_navbar(brand:, items: [], actions: [], variant: :default, size: :md, sticky: false, **options)
    classes = build_navbar_classes(variant: variant, size: size, sticky: sticky)
    content_tag(:nav, class: classes, **options) do
      ui_container(size: :fluid, padding: :none) do
        content_tag(:div, class: "flex items-center justify-between h-full") do
          concat navbar_brand(brand)
          concat navbar_menu(items) if items.any?
          concat navbar_actions(actions) if actions.any?
        end
      end
    end
  end

  # ✅ SRP: Navbar brand/logo section
  def navbar_brand(brand)
    content_tag(:div, class: "kt-navbar-brand flex items-center") do
      if brand.is_a?(Hash)
        link_to(brand[:href] || "/", class: "flex items-center gap-2") do
          concat image_tag(brand[:logo], class: "h-8 w-auto") if brand[:logo]
          concat content_tag(:span, brand[:text], class: "font-semibold text-lg") if brand[:text]
        end
      else
        brand
      end
    end
  end

  # ✅ SRP: Navbar menu items
  def navbar_menu(items)
    content_tag(:div, class: "kt-navbar-menu hidden md:flex items-center space-x-1") do
      safe_join(items.map { |item| navbar_menu_item(item) })
    end
  end

  # ✅ SRP: Individual navbar menu item
  def navbar_menu_item(item)
    if item[:dropdown]
      navbar_dropdown_item(item)
    else
      link_to(item[:href] || "#", class: "kt-navbar-link px-3 py-2 rounded-md text-sm font-medium hover:bg-accent hover:text-accent-foreground transition-colors #{item[:active] ? 'bg-accent text-accent-foreground' : 'text-foreground'}") do
        concat item[:icon] if item[:icon]
        concat item[:text]
        concat ui_badge(text: item[:badge], size: :sm) if item[:badge]
      end
    end
  end

  # ✅ SRP: Navbar dropdown item
  def navbar_dropdown_item(item)
    content_tag(:div, class: "relative", data: { "kt-dropdown": true }) do
      concat navbar_dropdown_trigger(item)
      concat navbar_dropdown_menu(item[:dropdown])
    end
  end

  # ✅ SRP: Dropdown trigger
  def navbar_dropdown_trigger(item)
    button_tag(class: "kt-navbar-link flex items-center gap-1 px-3 py-2 rounded-md text-sm font-medium hover:bg-accent hover:text-accent-foreground transition-colors", data: { "kt-dropdown-toggle": true }) do
      concat item[:icon] if item[:icon]
      concat item[:text]
      concat ui_icon(name: "chevron-down", size: :sm)
    end
  end

  # ✅ SRP: Dropdown menu
  def navbar_dropdown_menu(items)
    content_tag(:div, class: "kt-dropdown-menu absolute right-0 mt-2 w-48 bg-background border border-border rounded-md shadow-lg z-50", data: { "kt-dropdown-menu": true }) do
      content_tag(:div, class: "py-1") do
        safe_join(items.map { |item| navbar_dropdown_menu_item(item) })
      end
    end
  end

  # ✅ SRP: Dropdown menu item
  def navbar_dropdown_menu_item(item)
    if item[:divider]
      content_tag(:div, "", class: "border-t border-border my-1")
    else
      link_to(item[:href] || "#", class: "flex items-center gap-2 px-4 py-2 text-sm hover:bg-accent hover:text-accent-foreground") do
        concat ui_icon(name: item[:icon], size: :sm) if item[:icon]
        concat item[:text]
      end
    end
  end

  # ✅ SRP: Navbar actions (right side)
  def navbar_actions(actions)
    content_tag(:div, class: "kt-navbar-actions flex items-center gap-2") do
      safe_join(actions.map { |action| action.respond_to?(:call) ? action.call : action })
    end
  end

  # ✅ SRP: Mobile menu toggle
  def navbar_mobile_toggle(target: "#mobile-menu")
    button_tag(class: "md:hidden p-2 rounded-md hover:bg-accent hover:text-accent-foreground", data: { "kt-drawer-toggle": target }) do
      ui_icon(name: "menu", size: :md)
    end
  end

  private

  def build_navbar_classes(variant:, size:, sticky:)
    classes = ["kt-navbar border-b border-border bg-background"]

    # Variant
    case variant
    when :transparent then classes << "bg-transparent border-transparent"
    when :colored then classes << "bg-primary text-primary-foreground border-primary"
    end

    # Size
    case size
    when :sm then classes << "h-12"
    when :md then classes << "h-16"
    when :lg then classes << "h-20"
    end

    # Sticky
    classes << "sticky top-0 z-40" if sticky

    classes.join(" ")
  end
end