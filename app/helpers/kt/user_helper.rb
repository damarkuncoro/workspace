# app/helpers/user_helper.rb
module KT::UserHelper
  # ===============================
  # 1️⃣ Dropdown Wrapper
  # ===============================
  def user_dropdown(user:, menu:)
    content_tag(:div,
                class: "shrink-0",
                data: {
                  "kt-dropdown": true,
                  "kt-dropdown-offset": "10px, 10px",
                  "kt-dropdown-offset-rtl": "-20px, 10px",
                  "kt-dropdown-placement": "bottom-end",
                  "kt-dropdown-placement-rtl": "bottom-start",
                  "kt-dropdown-trigger": "click"
                }) do
      concat user_avatar_toggle(user[:avatar])
      concat user_dropdown_menu(user:, menu:)
    end
  end

  # ===============================
  # 2️⃣ Avatar Toggle
  # ===============================
  def user_avatar_toggle(avatar)
    content_tag(:div, class: "cursor-pointer shrink-0", data: { "kt-dropdown-toggle": true }) do
      image_tag avatar, class: "size-9 rounded-full border-2 border-green-500 shrink-0", alt: "User Avatar"
    end
  end

  # ===============================
  # 3️⃣ Dropdown Menu
  # ===============================
  def user_dropdown_menu(user:, menu:)
    content_tag(:div, class: "kt-dropdown-menu w-[250px]", data: { "kt-dropdown-menu": true }) do
      concat user_profile_header(user)
      concat user_menu_list(menu[:sections])
      concat user_footer(menu[:footer])
    end
  end

  # ===============================
  # 4️⃣ Profil Header
  # ===============================
  def user_profile_header(user)
    content_tag(:div, class: "flex items-center justify-between px-2.5 py-1.5 gap-1.5") do
      concat(
        content_tag(:div, class: "flex items-center gap-2") do
          concat image_tag(user[:avatar], class: "size-9 shrink-0 rounded-full border-2 border-green-500", alt: "")
          concat(
            content_tag(:div, class: "flex flex-col gap-1.5") do
              concat content_tag(:span, user[:name], class: "text-sm text-foreground font-semibold leading-none")
              concat link_to(user[:email], user[:email_link] || "#", class: "text-xs text-secondary-foreground hover:text-primary font-medium leading-none")
            end
          )
        end
      )
      concat content_tag(:span, user[:badge], class: "kt-badge kt-badge-sm kt-badge-primary kt-badge-outline") if user[:badge]
    end
  end

  # ===============================
  # 5️⃣ Menu List
  # ===============================
  def user_menu_list(sections)
    content_tag(:ul, class: "kt-dropdown-menu-sub") do
      safe_join(
        sections.map do |section|
          concat content_tag(:li, "", class: "kt-dropdown-menu-separator") if section[:separator]
          concat(
            if section[:submenu]
              user_dropdown_submenu(section)
            else
              user_menu_link(section)
            end
          )
        end
      )
    end
  end

  # ===============================
  # 6️⃣ Menu Item (tanpa submenu)
  # ===============================
  def user_menu_link(item)
    content_tag(:li) do
      link_to(item[:href], class: "kt-dropdown-menu-link") do
        concat(content_tag(:i, "", class: "ki-filled #{item[:icon]}")) if item[:icon]
        concat item[:title]
        concat user_menu_switch(item[:switch]) if item[:switch]
      end
    end
  end

  # ===============================
  # 7️⃣ Submenu
  # ===============================
  def user_dropdown_submenu(item)
    content_tag(:li, data: { "kt-dropdown": true, "kt-dropdown-placement": "right-start", "kt-dropdown-trigger": "hover" }) do
      concat(
        button_tag(class: "kt-dropdown-menu-toggle", data: { "kt-dropdown-toggle": true }) do
          concat(content_tag(:i, "", class: "ki-filled #{item[:icon]}"))
          concat item[:title]
          concat(content_tag(:span, content_tag(:i, "", class: "ki-filled ki-right text-xs"), class: "kt-dropdown-menu-indicator"))
        end
      )
      concat(
        content_tag(:div, class: "kt-dropdown-menu w-[220px]", data: { "kt-dropdown-menu": true }) do
          content_tag(:ul, class: "kt-dropdown-menu-sub") do
            safe_join(item[:submenu].map { |sub| user_menu_link(sub) })
          end
        end
      )
    end
  end

  # ===============================
  # 8️⃣ Switch (Dark Mode, Notifications)
  # ===============================
  def user_menu_switch(switch)
    check_box_tag(:check, "1", switch[:checked], class: "ms-auto kt-switch", data: switch[:data] || {})
  end

  # ===============================
  # 9️⃣ Footer (Dark Mode + Logout)
  # ===============================
  def user_footer(footer)
    content_tag(:div, class: "px-2.5 pt-1.5 mb-2.5 flex flex-col gap-3.5") do
      concat(
        content_tag(:div, class: "flex items-center gap-2 justify-between") do
          concat(content_tag(:span, class: "flex items-center gap-2") do
            concat content_tag(:i, "", class: "ki-filled ki-moon text-base text-muted-foreground")
            concat content_tag(:span, "Dark Mode", class: "font-medium text-2sm")
          end)
          concat(check_box_tag(:dark_mode, "1", footer[:dark_mode], class: "kt-switch", data: { "kt-theme-switch-toggle": true }))
        end
      )
      concat(link_to("Log out", footer[:logout_path] || "#", class: "kt-btn kt-btn-outline justify-center w-full"))
    end
  end
end
