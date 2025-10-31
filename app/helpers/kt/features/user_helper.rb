# app/helpers/kt/features/user_helper.rb
module KT
  module Features
    module UserHelper
      include KT::UI::Base::BaseDropdownHelper
      include KT::UI::Base::BaseUIHelper

      # ===============================
      # 🔹 MAIN USER COMPONENTS
      # ===============================

      # ✅ SRP: Complete user dropdown - using base dropdown helpers
      def user_dropdown(user:, menu:)
        dropdown_wrapper(attributes: { "kt-dropdown-trigger": "click" }) do
          concat user_avatar_toggle(user[:avatar])
          concat user_dropdown_menu(user: user, menu: menu)
        end
      end

      # ===============================
      # 🔹 PRIVATE HELPERS
      # ===============================
      private

      # Avatar toggle - using base UI avatar
      def user_avatar_toggle(avatar)
        content_tag(:div, class: "cursor-pointer shrink-0", data: { "kt-dropdown-toggle": true }) do
          ui_avatar(src: avatar, size: "size-9", avatar_class: "rounded-full border-2 border-green-500 shrink-0")
        end
      end

      # Dropdown menu
      def user_dropdown_menu(user:, menu:)
        dropdown_menu_container(menu_class: "kt-dropdown-menu w-[250px]") do
          concat user_profile_header(user)
          concat user_menu_list(menu[:sections])
          concat user_footer(menu[:footer])
        end
      end

      # Profile header
      def user_profile_header(user)
        content_tag(:div, class: "flex items-center justify-between px-2.5 py-1.5 gap-1.5") do
          concat user_profile_info(user)
          concat ui_badge(text: user[:badge], type: :primary, size: :sm, outline: true) if user[:badge]
        end
      end

      # Profile info section
      def user_profile_info(user)
        content_tag(:div, class: "flex items-center gap-2") do
          concat ui_avatar(src: user[:avatar], size: "size-9", avatar_class: "shrink-0 rounded-full border-2 border-green-500")
          concat user_profile_details(user)
        end
      end

      # Profile details
      def user_profile_details(user)
        content_tag(:div, class: "flex flex-col gap-1.5") do
          concat content_tag(:span, user[:name], class: "text-sm text-foreground font-semibold leading-none")
          concat ui_link(text: user[:email], href: user[:email_link] || "#", link_class: "text-xs text-secondary-foreground hover:text-primary font-medium leading-none")
        end
      end

      # Menu list
      def user_menu_list(sections)
        content_tag(:ul, class: "kt-dropdown-menu-sub") do
          safe_join(sections.map { |section| user_menu_section(section) })
        end
      end

      # Menu section
      def user_menu_section(section)
        content = []
        content << content_tag(:li, "", class: "kt-dropdown-menu-separator") if section[:separator]
        content << (section[:submenu] ? user_dropdown_submenu(section) : user_menu_link(section))
        safe_join(content)
      end

      # Menu item (without submenu)
      def user_menu_link(item)
        content_tag(:li) do
          link_to(item[:href], class: "kt-dropdown-menu-link") do
            concat ui_icon(icon_class: "ki-filled #{item[:icon]}") if item[:icon]
            concat item[:title]
            concat user_menu_switch(item[:switch]) if item[:switch]
          end
        end
      end

      # Submenu
      def user_dropdown_submenu(item)
        content_tag(:li, data: { "kt-dropdown": true, "kt-dropdown-placement": "right-start", "kt-dropdown-trigger": "hover" }) do
          concat user_submenu_trigger(item)
          concat user_submenu_content(item[:submenu])
        end
      end

      # Submenu trigger
      def user_submenu_trigger(item)
        button_tag(class: "kt-dropdown-menu-toggle", data: { "kt-dropdown-toggle": true }) do
          concat ui_icon(icon_class: "ki-filled #{item[:icon]}")
          concat item[:title]
          concat content_tag(:span, ui_icon(icon_class: "ki-filled ki-right text-xs"), class: "kt-dropdown-menu-indicator")
        end
      end

      # Submenu content
      def user_submenu_content(submenu)
        content_tag(:div, class: "kt-dropdown-menu w-[220px]", data: { "kt-dropdown-menu": true }) do
          content_tag(:ul, class: "kt-dropdown-menu-sub") do
            safe_join(submenu.map { |sub| user_menu_link(sub) })
          end
        end
      end

      # Menu switch
      def user_menu_switch(switch)
        ui_switch(name: :check, checked: switch[:checked], switch_class: "ms-auto kt-switch", **(switch[:data] || {}))
      end

      # Footer
      def user_footer(footer)
        content_tag(:div, class: "px-2.5 pt-1.5 mb-2.5 flex flex-col gap-3.5") do
          concat user_dark_mode_toggle(footer[:dark_mode])
          concat ui_button(text: "Log out", variant: :outline, button_class: "justify-center w-full", href: footer[:logout_path] || "#")
        end
      end

      # Dark mode toggle
      def user_dark_mode_toggle(dark_mode)
        content_tag(:div, class: "flex items-center gap-2 justify-between") do
          concat user_dark_mode_label
          concat ui_switch(name: :dark_mode, checked: dark_mode, data: { "kt-theme-switch-toggle": true })
        end
      end

      # Dark mode label
      def user_dark_mode_label
        content_tag(:span, class: "flex items-center gap-2") do
          concat ui_icon(icon_class: "ki-filled ki-moon text-base text-muted-foreground")
          concat content_tag(:span, "Dark Mode", class: "font-medium text-2sm")
        end
      end
    end
  end
end
