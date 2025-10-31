# app/helpers/kt/components/menu_component.rb
module KT::Components::MenuComponent
  include KT::BaseUiHelper
  include KT::BaseMenuHelper
  include KT::BaseDropdownHelper

  # ✅ SRP: Context menu component
  def ui_context_menu(trigger:, items: [], placement: "bottom-start", **options)
    content_tag(:div, class: "kt-context-menu", data: { "kt-dropdown": true, "kt-dropdown-placement": placement }, **options) do
      concat context_menu_trigger(trigger)
      concat context_menu_dropdown(items)
    end
  end

  # ✅ SRP: Context menu trigger
  def context_menu_trigger(trigger)
    content_tag(:div, class: "kt-context-menu-trigger", data: { "kt-dropdown-toggle": true }) do
      trigger.respond_to?(:call) ? trigger.call : trigger
    end
  end

  # ✅ SRP: Context menu dropdown
  def context_menu_dropdown(items)
    dropdown_menu_container(menu_class: "kt-context-menu-dropdown") do
      content_tag(:ul, class: "kt-context-menu-list") do
        safe_join(items.map { |item| context_menu_item(item) })
      end
    end
  end

  # ✅ SRP: Context menu item
  def context_menu_item(item)
    content_tag(:li) do
      if item[:divider]
        menu_separator
      elsif item[:submenu]
        context_menu_item_with_submenu(item)
      else
        context_menu_item_simple(item)
      end
    end
  end

  # ✅ SRP: Simple context menu item
  def context_menu_item_simple(item)
    link_to(item[:href] || "#", class: "kt-context-menu-link flex items-center gap-2 px-3 py-2 text-sm hover:bg-accent hover:text-accent-foreground") do
      concat ui_icon(name: item[:icon], size: :sm) if item[:icon]
      concat item[:text]
      concat ui_icon(name: item[:shortcut_icon], size: :xs, wrapper_class: "ml-auto opacity-50") if item[:shortcut]
      concat content_tag(:kbd, item[:shortcut], class: "ml-auto text-xs opacity-50") if item[:shortcut]
    end
  end

  # ✅ SRP: Context menu item with submenu
  def context_menu_item_with_submenu(item)
    content_tag(:div, class: "kt-context-submenu", data: { "kt-dropdown": true, "kt-dropdown-placement": "right-start" }) do
      concat context_menu_item_simple(item.except(:submenu).merge(href: nil, "data-kt-dropdown-toggle": true))
      concat context_menu_dropdown(item[:submenu])
    end
  end

  # ✅ SRP: Dropdown menu component
  def ui_dropdown_menu(trigger:, items: [], variant: :default, **options)
    content_tag(:div, class: "kt-dropdown-menu-wrapper", data: { "kt-dropdown": true }, **options) do
      concat dropdown_trigger_button(icon: trigger[:icon] || "dots-vertical")
      concat dropdown_menu_container do
        content_tag(:ul, class: "kt-dropdown-menu-list") do
          safe_join(items.map { |item| dropdown_menu_item(item, variant) })
        end
      end
    end
  end

  # ✅ SRP: Dropdown menu item
  def dropdown_menu_item(item, variant)
    content_tag(:li) do
      if item[:divider]
        menu_separator
      else
        link_to(item[:href] || "#", class: "kt-dropdown-menu-link flex items-center gap-2 px-3 py-2 text-sm hover:bg-accent hover:text-accent-foreground") do
          concat ui_icon(name: item[:icon], size: :sm) if item[:icon]
          concat item[:text]
          concat item[:badge] if item[:badge]
        end
      end
    end
  end

  # ✅ SRP: Action menu (icon buttons)
  def ui_action_menu(actions: [], variant: :ghost, size: :sm, **options)
    content_tag(:div, class: "kt-action-menu flex items-center gap-1", **options) do
      safe_join(actions.map { |action| action_button(action, variant, size) })
    end
  end

  # ✅ SRP: Individual action button
  def action_button(action, variant, size)
    ui_button(
      text: action[:text],
      icon: action[:icon],
      variant: variant,
      size: size,
      class: action[:class],
      data: action[:data],
      href: action[:href]
    )
  end

  # ✅ SRP: Navigation menu
  def ui_nav_menu(items: [], orientation: :horizontal, variant: :default, **options)
    menu_class = build_nav_menu_class(orientation, variant)

    content_tag(:nav, class: menu_class, **options) do
      content_tag(:ul, class: orientation == :vertical ? "space-y-1" : "flex gap-4") do
        safe_join(items.map { |item| nav_menu_item(item, orientation) })
      end
    end
  end

  # ✅ SRP: Navigation menu item
  def nav_menu_item(item, orientation)
    content_tag(:li) do
      link_to(item[:href] || "#", class: "kt-nav-menu-link #{item[:active] ? 'active' : ''}") do
        concat ui_icon(name: item[:icon], size: :sm) if item[:icon]
        concat item[:text]
        concat ui_badge(text: item[:badge], size: :xs) if item[:badge]
      end
    end
  end

  private

  def build_nav_menu_class(orientation, variant)
    classes = ["kt-nav-menu"]

    case orientation
    when :vertical then classes << "kt-nav-menu-vertical"
    else classes << "kt-nav-menu-horizontal"
    end

    case variant
    when :pills then classes << "kt-nav-menu-pills"
    when :underline then classes << "kt-nav-menu-underline"
    else classes << "kt-nav-menu-default"
    end

    classes.join(" ")
  end
end