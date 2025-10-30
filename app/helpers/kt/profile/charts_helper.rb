module KT::Profile::ChartsHelper
  # Blog Partnership Card
  def blog_partnership_card
    content_tag(:div, class: "kt-card") do
      concat(content_tag(:div, class: "kt-card-content px-10 py-7.5 lg:pe-12.5") do
        content_tag(:div, class: "flex flex-wrap md:flex-nowrap items-center gap-6 md:gap-10") do
          concat(content_tag(:div, class: "flex flex-col gap-3") do
            concat(content_tag(:h2, "Unlock Creative<br/>Partnerships on Our Blog".html_safe, class: "text-xl font-semibold text-mono"))
            concat(content_tag(:p, "Explore exciting collaboration opportunities with our blog. We're open to partnerships, guest posts, and more. Join us to share your insights and grow your audience.", class: "text-sm text-secondary-foreground leading-5.5"))
          end)
          concat(image_tag("/assets/media/illustrations/1.svg", alt: "image", class: "dark:hidden max-h-[160px]"))
          concat(image_tag("/assets/media/illustrations/1-dark.svg", alt: "image", class: "light:hidden max-h-[160px]"))
        end
      end)
      concat(content_tag(:div, class: "kt-card-footer justify-center") do
        link_to("Get Started", "/demo1/network/get-started.html", class: "kt-link kt-link-underlined kt-link-dashed")
      end)
    end
  end

  # Media Uploads Chart Card
  def media_uploads_chart_card
    content_tag(:div, class: "kt-card") do
      concat(content_tag(:div, class: "kt-card-header") do
        concat(content_tag(:h3, "Media Uploads", class: "kt-card-title"))
        concat(media_uploads_menu)
      end)
      concat(content_tag(:div, class: "px-3 py-1") do
        content_tag(:div, id: "media_uploads_chart")
      end)
    end
  end

  # Assistance Chart Card
  def assistance_chart_card
    content_tag(:div, class: "kt-card") do
      concat(content_tag(:div, class: "kt-card-header") do
        concat(content_tag(:h3, "Assistance", class: "kt-card-title"))
        concat(assistance_menu)
      end)
      concat(content_tag(:div, class: "kt-card-content flex justify-center items-center px-3 py-1") do
        content_tag(:div, id: "contributions_chart")
      end)
    end
  end

  private

  def media_uploads_menu
    content_tag(:div, class: "kt-menu", data: { "kt-menu": true }) do
      content_tag(:div, class: "kt-menu-item", data: { "kt-menu-item-offset": "0, 10px", "kt-menu-item-placement": "bottom-end", "kt-menu-item-placement-rtl": "bottom-start", "kt-menu-item-toggle": "dropdown", "kt-menu-item-trigger": "click" }) do
        concat(button_tag(class: "kt-menu-toggle kt-btn kt-btn-sm kt-btn-icon kt-btn-ghost") do
          content_tag(:i, "", class: "ki-filled ki-dots-vertical text-lg")
        end)
        concat(content_tag(:div, class: "kt-menu-dropdown kt-menu-default w-full max-w-[200px]", data: { "kt-menu-dismiss": true }) do
          safe_join([
            menu_item_link("Settings", "/demo1/account/home/settings-enterprise.html", "ki-setting-3"),
            menu_item_link("Import", "/demo1/account/members/import-members.html", "ki-some-files"),
            menu_item_link("Activity", "/demo1/account/activity.html", "ki-cloud-change"),
            menu_item_link("Report", "#", "ki-dislike", data: { "kt-modal-toggle": "#report_user_modal" })
          ])
        end)
      end
    end
  end

  def assistance_menu
    content_tag(:div, class: "kt-menu", data: { "kt-menu": true }) do
      content_tag(:div, class: "kt-menu-item", data: { "kt-menu-item-offset": "0, 10px", "kt-menu-item-placement": "bottom-end", "kt-menu-item-placement-rtl": "bottom-start", "kt-menu-item-toggle": "dropdown", "kt-menu-item-trigger": "click" }) do
        concat(button_tag(class: "kt-menu-toggle kt-btn kt-btn-sm kt-btn-icon kt-btn-ghost") do
          content_tag(:i, "", class: "ki-filled ki-dots-vertical text-lg")
        end)
        concat(content_tag(:div, class: "kt-menu-dropdown kt-menu-default w-full max-w-[200px]", data: { "kt-menu-dismiss": true }) do
          safe_join([
            menu_item_link("Settings", "/demo1/account/home/settings-enterprise.html", "ki-setting-3"),
            menu_item_link("Import", "/demo1/account/members/import-members.html", "ki-some-files"),
            menu_item_link("Activity", "/demo1/account/activity.html", "ki-cloud-change"),
            menu_item_link("Report", "#", "ki-dislike", data: { "kt-modal-toggle": "#report_user_modal" })
          ])
        end)
      end
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