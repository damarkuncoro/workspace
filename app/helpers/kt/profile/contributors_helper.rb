module KT::Profile::ContributorsHelper
  # Contributors Card
  def contributors_card(contributors: [])
    content_tag(:div, class: "kt-card") do
      concat(content_tag(:div, class: "kt-card-header gap-2") do
        concat(content_tag(:h3, "Contributors", class: "kt-card-title"))
        concat(contributor_menu)
      end)
      concat(content_tag(:div, class: "kt-card-content") do
        content_tag(:div, class: "flex flex-col gap-2 lg:gap-5") do
          safe_join([
            contributor_item(
              avatar: "/assets/media/avatars/300-3.png",
              name: "Tyler Hero",
              count: "6 contributors"
            ),
            contributor_item(
              avatar: "/assets/media/avatars/300-1.png",
              name: "Esther Howard",
              count: "29 contributors"
            ),
            contributor_item(
              avatar: "/assets/media/avatars/300-14.png",
              name: "Cody Fisher",
              count: "34 contributors"
            ),
            contributor_item(
              avatar: "/assets/media/avatars/300-7.png",
              name: "Arlene McCoy",
              count: "1 contributors"
            )
          ])
        end
      end)
      concat(content_tag(:div, class: "kt-card-footer justify-center") do
        link_to("All Contributors", "/demo1/public-profile/network.html", class: "kt-link kt-link-underlined kt-link-dashed")
      end)
    end
  end

  private

  def contributor_item(avatar:, name:, count:)
    content_tag(:div, class: "flex items-center gap-2") do
      concat(content_tag(:div, class: "flex items-center grow gap-2.5") do
        concat(image_tag(avatar, alt: "", class: "rounded-full size-9 shrink-0"))
        concat(content_tag(:div, class: "flex flex-col") do
          concat(link_to(name, "#", class: "text-sm font-semibold text-mono hover:text-primary mb-px"))
          concat(content_tag(:span, count, class: "text-xs font-semibold text-secondary-foreground"))
        end)
      end)
      concat(file_menu)
    end
  end

  def contributor_menu
    content_tag(:div, class: "kt-menu", data: { "kt-menu": true }) do
      content_tag(:div, class: "kt-menu-item", data: { "kt-menu-item-offset": "0, 10px", "kt-menu-item-placement": "bottom-end", "kt-menu-item-placement-rtl": "bottom-start", "kt-menu-item-toggle": "dropdown", "kt-menu-item-trigger": "click" }) do
        concat(button_tag(class: "kt-menu-toggle kt-btn kt-btn-sm kt-btn-icon kt-btn-ghost") do
          content_tag(:i, "", class: "ki-filled ki-dots-vertical text-lg")
        end)
        concat(content_tag(:div, class: "kt-menu-dropdown kt-menu-default w-full max-w-[200px]", data: { "kt-menu-dismiss": true }) do
          safe_join([
            menu_item_link("Activity", "/demo1/account/activity.html", "ki-cloud-change"),
            menu_item_link("Share", "#", "ki-share", data: { "kt-modal-toggle": "#share_profile_modal" }),
            submenu_notifications,
            menu_item_link("Report", "#", "ki-dislike", data: { "kt-modal-toggle": "#report_user_modal" }),
            content_tag(:div, "", class: "kt-menu-separator"),
            menu_item_link("Settings", "/demo1/account/home/settings-enterprise.html", "ki-setting-3")
          ])
        end)
      end
    end
  end

  def file_menu
    content_tag(:div, class: "kt-menu", data: { "kt-menu": true }) do
      content_tag(:div, class: "kt-menu-item", data: { "kt-menu-item-offset": "0, 10px", "kt-menu-item-placement": "bottom-end", "kt-menu-item-placement-rtl": "bottom-start", "kt-menu-item-toggle": "dropdown", "kt-menu-item-trigger": "click" }) do
        concat(button_tag(class: "kt-menu-toggle kt-btn kt-btn-sm kt-btn-icon kt-btn-ghost") do
          content_tag(:i, "", class: "ki-filled ki-dots-vertical text-lg")
        end)
        concat(content_tag(:div, class: "kt-menu-dropdown kt-menu-default w-full max-w-[175px]", data: { "kt-menu-dismiss": true }) do
          safe_join([
            menu_item_link("Details", "#", "ki-document"),
            menu_item_link("Share", "#", "ki-share", data: { "kt-modal-toggle": "#share_profile_modal" }),
            menu_item_link("Export", "#", "ki-file-up")
          ])
        end)
      end
    end
  end

  def submenu_notifications
    content_tag(:div, class: "kt-menu-item", data: { "kt-menu-item-offset": "-15px, 0", "kt-menu-item-placement": "right-start", "kt-menu-item-toggle": "dropdown", "kt-menu-item-trigger": "click|lg:hover" }) do
      concat(content_tag(:div, class: "kt-menu-link") do
        concat(content_tag(:span, class: "kt-menu-icon") do
          content_tag(:i, "", class: "ki-filled ki-notification-status")
        end)
        concat(content_tag(:span, "Notifications", class: "kt-menu-title"))
        concat(content_tag(:span, class: "kt-menu-arrow") do
          content_tag(:i, "", class: "ki-filled ki-right text-xs rtl:transform rtl:rotate-180")
        end)
      end)
      concat(content_tag(:div, class: "kt-menu-dropdown kt-menu-default w-full max-w-[175px]") do
        safe_join([
          menu_item_link("Email", "/demo1/account/home/settings-sidebar.html", "ki-sms"),
          menu_item_link("SMS", "/demo1/account/home/settings-sidebar.html", "ki-message-notify"),
          menu_item_link("Push", "/demo1/account/home/settings-sidebar.html", "ki-notification-status")
        ])
      end)
    end
  end

  def menu_item_link(title, href, icon, data: {})
    content_tag(:div, class: "kt-menu-item") do
      link_to(href, class: "kt-menu-link", data: data) do
        concat(content_tag(:span, class: "kt-menu-icon") do
          content_tag(:i, "", class: "ki-filled #{icon}")
        end)
        concat(content_tag(:span, title, class: "kt-menu-title"))
      end
    end
  end
end