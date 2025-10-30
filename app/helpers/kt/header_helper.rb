# app/helpers/kt/header_helper.rb
module KT::HeaderHelper
  # ✅ SRP: logo utama (mobile & desktop)
  def header_logo(src: "/assets/media/app/mini-logo.svg", href: "/")
    link_to(href, class: "shrink-0") do
      image_tag(src, class: "max-h-[25px] w-full")
    end
  end

  # ✅ SRP: tombol icon (drawer/modal)
  def header_button(icon:, target:, tooltip: nil)
    button_tag(class: "kt-btn kt-btn-icon kt-btn-ghost", data: { "kt-drawer-toggle": target, "bs-tooltip": tooltip }) do
      content_tag(:i, "", class: "ki-filled #{icon}")
    end
  end

  # ✅ SRP: item menu utama
  def menu_item(title:, href:, icon: nil, badge: nil, active: false)
    classes = "kt-menu-item #{'active' if active}"
    link_classes = "kt-menu-link text-nowrap text-sm text-foreground font-medium kt-menu-link-hover:text-primary kt-menu-item-hover:text-primary kt-menu-item-active:text-mono kt-menu-item-active:font-medium kt-menu-item-here:text-mono kt-menu-item-here:font-medium"
    content_tag(:div, class: classes) do
      link_to(href, class: link_classes) do
        concat(content_tag(:span, content_tag(:i, "", class: "ki-filled #{icon}"), class: "kt-menu-icon")) if icon
        concat(content_tag(:span, title, class: "kt-menu-title text-nowrap"))
        concat(content_tag(:span, badge_tag(badge), class: "kt-menu-badge")) if badge
      end
    end
  end

  # ✅ SRP: megamenu dropdown
  def menu_dropdown(title:, items:, columns: 2, offset: nil, placement: "bottom-start", placement_rtl: "bottom-end", toggle: "accordion|lg:dropdown", trigger: "click|lg:hover", footer: nil)
    data_attrs = { "kt-menu-item-toggle": toggle, "kt-menu-item-trigger": trigger }
    data_attrs["kt-menu-item-offset"] = offset if offset
    data_attrs["kt-menu-item-placement"] = placement
    data_attrs["kt-menu-item-placement-rtl"] = placement_rtl
    data_attrs["kt-menu-item-overflow"] = "true" if offset

    content_tag(:div, class: "kt-menu-item", data: data_attrs) do
      concat(content_tag(:div, class: "kt-menu-link text-sm text-secondary-foreground font-medium kt-menu-link-hover:text-primary kt-menu-item-active:text-mono kt-menu-item-show:text-primary kt-menu-item-here:text-mono kt-menu-item-active:font-semibold kt-menu-item-here:font-semibold") do
        concat(content_tag(:span, title, class: "kt-menu-title text-nowrap"))
        concat(content_tag(:span, class: "kt-menu-arrow flex lg:hidden") do
          concat(content_tag(:span, class: "kt-menu-item-show:hidden text-muted-foreground") do
            content_tag(:i, "", class: "ki-filled ki-plus text-xs")
          end)
          concat(content_tag(:span, class: "hidden kt-menu-item-show:inline-flex") do
            content_tag(:i, "", class: "ki-filled ki-minus text-xs")
          end)
        end)
      end)
      concat(content_tag(:div, class: "kt-menu-dropdown flex-col lg:flex-row gap-0 w-full lg:max-w-[#{columns == 2 ? '900px' : '1240px'}]") do
        concat(content_tag(:div, class: "pt-4 pb-2 lg:p-7.5") do
          content_tag(:div, class: "grid lg:grid-cols-#{columns} gap-5 lg:gap-10") do
            safe_join(items.map { |group| menu_group(group) })
          end
        end)
        if footer
          concat(content_tag(:div, class: "flex flex-wrap items-center lg:justify-between rounded-xl lg:rounded-t-none border border-border lg:border-0 lg:border-t lg:border-t-border px-4 py-4 lg:px-7.5 lg:py-5 gap-2.5 bg-muted/50") do
            concat(content_tag(:div, class: "flex flex-col gap-1.5") do
              concat(content_tag(:div, footer[:title], class: "text-base font-semibold text-mono leading-none"))
              concat(content_tag(:div, footer[:subtitle], class: "text-sm fomt-medium text-secondary-foreground"))
            end)
            concat(link_to(footer[:button_text], footer[:button_href], class: "kt-btn kt-btn-mono"))
          end)
        end
      end)
    end
  end

  # ✅ SRP: grup menu dalam dropdown
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

  # ✅ SRP: badge
  def badge_tag(text)
    content_tag(:span, text, class: "kt-badge kt-badge-sm")
  end

  # ✅ SRP: tombol pencarian
  def search_button
    button_tag(class: "group kt-btn kt-btn-ghost kt-btn-icon size-9 rounded-full hover:bg-primary/10 hover:[&_i]:text-primary",
               data: { "kt-modal-toggle": "#search_modal" }) do
      content_tag(:i, "", class: "ki-filled ki-magnifier text-lg group-hover:text-primary")
    end
  end

  # ✅ SRP: tombol notifikasi
  def notification_button
    button_tag(class: "kt-btn kt-btn-ghost kt-btn-icon size-9 rounded-full hover:bg-primary/10 hover:[&_i]:text-primary",
               data: { "kt-drawer-toggle": "#notifications_drawer" }) do
      content_tag(:i, "", class: "ki-filled ki-notification-status text-lg")
    end
  end

  # ✅ SRP: tombol chat
  def chat_toggle_button
    button_tag(class: "kt-btn kt-btn-ghost kt-btn-icon size-9 rounded-full hover:bg-primary/10 hover:[&_i]:text-primary",
                data: { "kt-drawer-toggle": "#chat_drawer" }) do
      content_tag(:i, "", class: "ki-filled ki-messages text-lg")
    end
  end

  # ✅ SRP: tombol apps
  def apps_button
    content_tag(:div, data: { "kt-dropdown": "true", "kt-dropdown-offset": "10px, 10px", "kt-dropdown-offset-rtl": "-10px, 10px", "kt-dropdown-placement": "bottom-end", "kt-dropdown-placement-rtl": "bottom-start" }) do
      concat(button_tag(class: "kt-btn kt-btn-ghost kt-btn-icon size-9 rounded-full hover:bg-primary/10 hover:[&_i]:text-primary kt-dropdown-open:bg-primary/10 kt-dropdown-open:[&_i]:text-primary",
                        data: { "kt-dropdown-toggle": "true" }) do
        content_tag(:i, "", class: "ki-filled ki-element-11 text-lg")
      end)
      concat(content_tag(:div, class: "kt-dropdown-menu p-0 w-screen max-w-[320px]", data: { "kt-dropdown-menu": "true" }) do
        concat(content_tag(:div, class: "flex items-center justify-between gap-2.5 text-xs text-secondary-foreground font-medium px-5 py-3 border-b border-b-border") do
          concat(content_tag(:span, "Apps"))
          concat(content_tag(:span, "Enabled"))
        end)
        concat(content_tag(:div, class: "flex flex-col kt-scrollable-y-auto max-h-[400px] divide-y divide-border") do
          # Apps items would be added here
        end)
        concat(content_tag(:div, class: "grid p-5 border-t border-t-border") do
          link_to("Go to Apps", "/demo1/account/integrations.html", class: "kt-btn kt-btn-outline justify-center")
        end)
      end)
    end
  end

  # ✅ SRP: tombol user
  def user_button
    content_tag(:div, class: "shrink-0", data: { "kt-dropdown": "true", "kt-dropdown-offset": "10px, 10px", "kt-dropdown-offset-rtl": "-20px, 10px", "kt-dropdown-placement": "bottom-end", "kt-dropdown-placement-rtl": "bottom-start", "kt-dropdown-trigger": "click" }) do
      concat(content_tag(:div, class: "cursor-pointer shrink-0", data: { "kt-dropdown-toggle": "true" }) do
        image_tag("/assets/media/avatars/300-2.png", alt: "", class: "size-9 rounded-full border-2 border-green-500 shrink-0")
      end)
      concat(content_tag(:div, class: "kt-dropdown-menu w-[250px]", data: { "kt-dropdown-menu": "true" }) do
        concat(content_tag(:div, class: "flex items-center justify-between px-2.5 py-1.5 gap-1.5") do
          concat(content_tag(:div, class: "flex items-center gap-2") do
            concat(image_tag("/assets/media/avatars/300-2.png", alt: "", class: "size-9 shrink-0 rounded-full border-2 border-green-500"))
            concat(content_tag(:div, class: "flex flex-col gap-1.5") do
              concat(content_tag(:span, "Cody Fisher", class: "text-sm text-foreground font-semibold leading-none"))
              concat(link_to("c.fisher@gmail.com", "/demo1/account/home/get-started.html", class: "text-xs text-secondary-foreground hover:text-primary font-medium leading-none"))
            end)
          end)
          concat(content_tag(:span, "Pro", class: "kt-badge kt-badge-sm kt-badge-primary kt-badge-outline"))
        end)
        concat(content_tag(:ul, class: "kt-dropdown-menu-sub") do
          # User menu items would be added here
        end)
        concat(content_tag(:div, class: "px-2.5 pt-1.5 mb-2.5 flex flex-col gap-3.5") do
          concat(content_tag(:div, class: "flex items-center gap-2 justify-between") do
            concat(content_tag(:span, class: "flex items-center gap-2") do
              concat(content_tag(:i, "", class: "ki-filled ki-moon text-base text-muted-foreground"))
              concat(content_tag(:span, "Dark Mode", class: "font-medium text-2sm"))
            end)
            concat(tag(:input, class: "kt-switch", data: { "kt-theme-switch-state": "dark", "kt-theme-switch-toggle": "true" }, name: "check", type: "checkbox", value: "1"))
          end)
          concat(link_to("Log out", "/demo1/authentication/classic/sign-in.html", class: "kt-btn kt-btn-outline justify-center w-full"))
        end)
      end)
    end
  end



end
