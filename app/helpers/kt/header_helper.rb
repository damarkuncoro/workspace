# app/helpers/kt/header_helper.rb
module KT::HeaderHelper
  include KT::BaseUiHelper
  include KT::BaseDropdownHelper
  include KT::BaseMenuHelper

  # ===============================
  # 🔹 LOGO & BASIC ELEMENTS
  # ===============================

  # ✅ SRP: Header logo
  def header_logo(src: "/assets/media/app/mini-logo.svg", href: "/")
    link_to(href, class: "shrink-0") do
      image_tag(src, class: "max-h-[25px] w-full")
    end
  end

  # ✅ SRP: Generic header button
  def header_button(icon:, target:, tooltip: nil, button_class: "kt-btn kt-btn-icon kt-btn-ghost")
    ui_button(icon: icon, variant: :ghost, size: :default, button_class: "#{button_class} size-9 rounded-full hover:bg-primary/10 hover:[&_i]:text-primary",
              data: { "kt-drawer-toggle": target, "bs-tooltip": tooltip })
  end

  # ===============================
  # 🔹 MENU ITEMS
  # ===============================

  # ✅ SRP: Simple menu item - using base menu helpers
  def menu_item(title:, href:, icon: nil, badge: nil, active: false)
    menu_item_wrapper do
      menu_link(href: href, link_class: menu_item_link_classes(active)) do
        concat menu_icon(icon_class: "ki-filled #{icon}") if icon
        concat menu_title(title: title, title_class: "kt-menu-title text-nowrap")
        concat menu_badge(badge_text: badge) if badge
      end
    end
  end

  # ✅ SRP: Mega menu dropdown - using base helpers
  def menu_dropdown(title:, items:, columns: 2, offset: nil, placement: "bottom-start", placement_rtl: "bottom-end", toggle: "accordion|lg:dropdown", trigger: "click|lg:hover", footer: nil)
    data_attrs = {
      "kt-menu-item-toggle": toggle,
      "kt-menu-item-trigger": trigger,
      "kt-menu-item-placement": placement,
      "kt-menu-item-placement-rtl": placement_rtl
    }
    data_attrs["kt-menu-item-offset"] = offset if offset
    data_attrs["kt-menu-item-overflow"] = "true" if offset

    menu_item_wrapper(data_attrs: data_attrs) do
      concat menu_dropdown_trigger(title)
      concat menu_dropdown_content(items, columns, footer)
    end
  end

  # ✅ SRP: Menu group within dropdown
  def menu_group(group)
    content_tag(:div, class: "kt-menu kt-menu-default kt-menu-fit flex-col") do
      concat(content_tag(:h3, group[:title], class: "text-sm text-foreground font-semibold leading-none ps-2.5 mb-2 lg:mb-5"))
      concat(content_tag(:div, class: "grid lg:grid-cols-2 lg:gap-5") do
        concat(content_tag(:div, class: "flex flex-col gap-0.5") do
          safe_join(group[:links].take(group[:links].size / 2 + group[:links].size % 2).map { |l| menu_item(**l) })
        end)
        concat(content_tag(:div) do
          safe_join(group[:links].drop(group[:links].size / 2 + group[:links].size % 2).map { |l| menu_item(**l) })
        end) if group[:links].size > 1
      end)
    end
  end

  # ===============================
  # 🔹 ACTION BUTTONS
  # ===============================

  # ✅ SRP: Search button
  def search_button
    header_button(icon: "ki-magnifier", target: "#search_modal")
  end

  # ✅ SRP: Notification button
  def notification_button
    header_button(icon: "ki-notification-status", target: "#notifications_drawer")
  end

  # ✅ SRP: Chat button
  def chat_toggle_button
    header_button(icon: "ki-messages", target: "#chat_drawer")
  end

  # ✅ SRP: Apps button - using base dropdown helpers
  def apps_button
    dropdown_wrapper do
      concat dropdown_trigger_button(icon: "ki-element-11")
      concat dropdown_menu_container(menu_class: "kt-dropdown-menu p-0 w-screen max-w-[320px]") do
        concat dropdown_header_section(title: "Apps", subtitle: "Enabled")
        concat dropdown_list_section(items: [])
        concat dropdown_footer_section(content: ui_link(text: "Go to Apps", href: "/demo1/account/integrations.html", link_class: "kt-btn kt-btn-outline justify-center"))
      end
    end
  end

  # ✅ SRP: User button - using base dropdown helpers
  def user_button
    dropdown_wrapper(attributes: { "kt-dropdown-trigger": "click" }) do
      concat user_avatar_toggle
      concat user_dropdown_menu
    end
  end

  private

  # Menu item link classes
  def menu_item_link_classes(active)
    base_classes = "kt-menu-link text-nowrap text-sm text-foreground font-medium kt-menu-link-hover:text-primary kt-menu-item-hover:text-primary"
    active_classes = "kt-menu-item-active:text-mono kt-menu-item-active:font-medium kt-menu-item-here:text-mono kt-menu-item-here:font-medium"
    active ? "#{base_classes} #{active_classes}" : base_classes
  end

  # Menu dropdown trigger
  def menu_dropdown_trigger(title)
    content_tag(:div, class: "kt-menu-link text-sm text-secondary-foreground font-medium kt-menu-link-hover:text-primary kt-menu-item-active:text-mono kt-menu-item-show:text-primary kt-menu-item-here:text-mono kt-menu-item-active:font-semibold kt-menu-item-here:font-semibold") do
      concat menu_title(title: title, title_class: "kt-menu-title text-nowrap")
      concat menu_arrow
    end
  end

  # Menu dropdown content
  def menu_dropdown_content(items, columns, footer)
    content_tag(:div, class: "kt-menu-dropdown flex-col lg:flex-row gap-0 w-full lg:max-w-[#{columns == 2 ? '900px' : '1240px'}]") do
      concat(content_tag(:div, class: "pt-4 pb-2 lg:p-7.5") do
        content_tag(:div, class: "grid lg:grid-cols-#{columns} gap-5 lg:gap-10") do
          safe_join(items.map { |group| menu_group(group) })
        end
      end)
      if footer
        concat(content_tag(:div, class: "flex flex-wrap items-center lg:justify-between rounded-xl lg:rounded-t-none border border-border lg:border-0 lg:border-t lg:border-t-border px-4 py-4 lg:px-7.5 lg:py-5 gap-2.5 bg-muted/50") do
          concat(content_tag(:div, class: "flex flex-col gap-1.5") do
            concat(content_tag(:div, footer[:title], class: "text-base font-semibold text-mono leading-none"))
            concat(content_tag(:div, footer[:subtitle], class: "text-sm font-medium text-secondary-foreground"))
          end)
          concat ui_button(text: footer[:button_text], type: :primary, button_class: "kt-btn kt-btn-mono")
        end)
      end
    end
  end

  # User avatar toggle
  def user_avatar_toggle
    content_tag(:div, class: "cursor-pointer shrink-0", data: { "kt-dropdown-toggle": true }) do
      ui_avatar(src: "/assets/media/avatars/300-2.png", size: "size-9", avatar_class: "rounded-full border-2 border-green-500 shrink-0")
    end
  end

  # User dropdown menu
  def user_dropdown_menu
    dropdown_menu_container(menu_class: "kt-dropdown-menu w-[250px]") do
      concat user_profile_header
      concat user_menu_list
      concat user_footer
    end
  end

  # User profile header
  def user_profile_header
    content_tag(:div, class: "flex items-center justify-between px-2.5 py-1.5 gap-1.5") do
      concat(content_tag(:div, class: "flex items-center gap-2") do
        concat ui_avatar(src: "/assets/media/avatars/300-2.png", size: "size-9", avatar_class: "shrink-0 rounded-full border-2 border-green-500")
        concat(content_tag(:div, class: "flex flex-col gap-1.5") do
          concat(content_tag(:span, "Cody Fisher", class: "text-sm text-foreground font-semibold leading-none"))
          concat ui_link(text: "c.fisher@gmail.com", href: "/demo1/account/home/get-started.html", link_class: "text-xs text-secondary-foreground hover:text-primary font-medium leading-none")
        end)
      end)
      concat ui_badge(text: "Pro", type: :primary, size: :sm, outline: true)
    end
  end

  # User menu list (placeholder)
  def user_menu_list
    content_tag(:ul, class: "kt-dropdown-menu-sub") do
      # User menu items would be added here
    end
  end

  # User footer
  def user_footer
    content_tag(:div, class: "px-2.5 pt-1.5 mb-2.5 flex flex-col gap-3.5") do
      concat(content_tag(:div, class: "flex items-center gap-2 justify-between") do
        concat(content_tag(:span, class: "flex items-center gap-2") do
          concat ui_icon(icon_class: "ki-filled ki-moon", size: "text-base", icon_wrapper_class: "text-muted-foreground")
          concat(content_tag(:span, "Dark Mode", class: "font-medium text-2sm"))
        end)
        concat ui_switch(name: "check", data: { "kt-theme-switch-state": "dark", "kt-theme-switch-toggle": true })
      end)
      concat ui_button(text: "Log out", variant: :outline, button_class: "kt-btn justify-center w-full", **{ href: "/demo1/authentication/classic/sign-in.html" })
    end
  end
end
