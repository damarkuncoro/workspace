
# app/helpers/kt/notification_helper.rb
module KT::NotificationHelper
  # ✅ SRP: tombol notifikasi
  def notification_toggle_button
    button_tag(class: "kt-btn kt-btn-ghost kt-btn-icon size-9 rounded-full hover:bg-primary/10 hover:[&_i]:text-primary",
                data: { "kt-drawer-toggle": "#notifications_drawer" }) do
      content_tag(:i, "", class: "ki-filled ki-notification-status text-lg")
    end
  end

  
  # === Kerangka utama ===
  def notifications_drawer(notifications:, tabs:)
    content_tag(:div, id: "notifications_drawer",
                      class: "hidden kt-drawer kt-drawer-end card flex-col max-w-[90%] w-[450px] top-5 bottom-5 end-5 rounded-xl border border-border",
                      data: { "kt-drawer": true, "kt-drawer-container": "body" }) do
      concat drawer_header
      concat drawer_tabs(tabs)
      concat notification_tabs_content(notifications)
    end
  end

  # === Header Drawer ===
  def drawer_header
    content_tag(:div, class: "flex items-center justify-between gap-2.5 text-sm text-mono font-semibold px-5 py-2.5 border-b border-b-border", id: "notifications_header") do
      concat "Notifications"
      concat(
        button_tag(class: "kt-btn kt-btn-sm kt-btn-icon kt-btn-dim shrink-0", data: { "kt-drawer-dismiss": true }) do
          content_tag(:i, "", class: "ki-filled ki-cross")
        end
      )
    end
  end

  # === Tabs Button ===
  def drawer_tabs(tabs)
    content_tag(:div, class: "kt-tabs kt-tabs-line justify-between px-5 mb-2", data: { "kt-tabs": true }, id: "notifications_tabs") do
      content_tag(:div, class: "flex items-center gap-5") do
        safe_join(
          tabs.map do |tab|
            notification_tab_button(**tab)
          end
        )
      end
    end
  end

  # === Tombol Tab Individual ===
  def notification_tab_button(title:, target:, active: false, indicator: false)
    classes = "kt-tab-toggle py-3 #{'active' if active} relative"
    content_tag(:button, class: classes, data: { "kt-tab-toggle": target }) do
      concat title
      concat(content_tag(:span, "", class: "rounded-full bg-green-500 size-[5px] absolute top-2 rtl:start-0 end-0 transform translate-y-1/2 translate-x-full")) if indicator
    end
  end

  # === Konten Setiap Tab ===
  def notification_tabs_content(notifications)
    safe_join(
      notifications.map do |tab_id, items|
        content_tag(:div, id: tab_id, class: "grow flex flex-col #{tab_id == 'notifications_tab_all' ? '' : 'hidden'}") do
          concat(
            content_tag(:div, class: "grow kt-scrollable-y-auto", data: { "kt-scrollable": true, "kt-scrollable-dependencies": "#header", "kt-scrollable-max-height": "auto", "kt-scrollable-offset": "150px" }) do
              content_tag(:div, class: "grow flex flex-col gap-5 pt-3 pb-4 divider-y divider-border") do
                safe_join(items.map { |item| notification_item(item) })
              end
            end
          )
          concat notification_footer(actions: ["Archive all", "Mark all as read"])
        end
      end
    )
  end

  # === Item Notifikasi ===
  def notification_item(item)
    content_tag(:div, class: "flex grow gap-2.5 px-5") do
      concat notification_avatar(image: item[:avatar], status: item[:status])
      concat(
        content_tag(:div, class: "flex flex-col gap-3.5 grow") do
          concat(
            content_tag(:div, class: "flex flex-col gap-1") do
              concat(content_tag(:div, item[:message].html_safe, class: "text-sm font-medium"))
              concat(content_tag(:span, item[:meta], class: "flex items-center text-xs font-medium text-muted-foreground"))
            end
          )
          concat notification_buttons(actions: item[:actions]) if item[:actions]
          concat(
            content_tag(:div, class: "flex flex-wrap gap-2.5") do
              safe_join(item[:badges].map { |b| notification_badge(**b) })
            end
          ) if item[:badges]
        end
      )
    end
  end

  # === Avatar ===
  def notification_avatar(image:, status:)
    content_tag(:div, class: "kt-avatar size-8") do
      concat(content_tag(:div, image_tag(image, alt: "avatar"), class: "kt-avatar-image"))
      concat(
        content_tag(:div, class: "kt-avatar-indicator -end-2 -bottom-2") do
          content_tag(:div, "", class: "kt-avatar-status kt-avatar-status-#{status} size-2.5")
        end
      )
    end
  end

  # === Badge ===
  def notification_badge(type:, text:)
    content_tag(:span, text, class: "kt-badge kt-badge-sm kt-badge-#{type} kt-badge-outline")
  end

  # === Tombol Aksi ===
  def notification_buttons(actions:)
    content_tag(:div, class: "flex flex-wrap gap-2.5") do
      safe_join(
        actions.map do |a|
          button_tag(a, class: "kt-btn kt-btn-#{a.downcase == 'accept' ? 'mono' : 'outline'} kt-btn-sm")
        end
      )
    end
  end

  # === Footer ===
  def notification_footer(actions:)
    content_tag(:div, class: "grid grid-cols-2 p-5 gap-2.5") do
      safe_join(
        actions.map do |a|
          button_tag(a, class: "kt-btn kt-btn-outline justify-center")
        end
      )
    end
  end
end
