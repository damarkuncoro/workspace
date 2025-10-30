# app/helpers/kt/apps_helper.rb
module KT::AppsHelper

  # ===============================
  # 1️⃣ Dropdown Trigger
  # ===============================
  def apps_dropdown_button
    button_tag(class: "kt-btn kt-btn-ghost kt-btn-icon size-9 rounded-full hover:bg-primary/10 hover:[&_i]:text-primary kt-dropdown-open:bg-primary/10 kt-dropdown-open:[&_i]:text-primary",
               data: { "kt-dropdown-toggle": true }) do
      content_tag(:i, "", class: "ki-filled ki-element-11 text-lg")
    end
  end

  # ===============================
  # 2️⃣ Dropdown Menu Wrapper
  # ===============================
  def apps_dropdown(apps:)
    content_tag(:div,
                class: "",
                data: {
                  "kt-dropdown": true,
                  "kt-dropdown-offset": "10px, 10px",
                  "kt-dropdown-placement": "bottom-end",
                  "kt-dropdown-placement-rtl": "bottom-start"
                }) do
      concat apps_dropdown_button
      concat(
        content_tag(:div, class: "kt-dropdown-menu p-0 w-screen max-w-[320px]", data: { "kt-dropdown-menu": true }) do
          concat apps_dropdown_header
          concat apps_list(apps)
          concat apps_dropdown_footer
        end
      )
    end
  end

  # ===============================
  # 3️⃣ Header
  # ===============================
  def apps_dropdown_header
    content_tag(:div, class: "flex items-center justify-between gap-2.5 text-xs text-secondary-foreground font-medium px-5 py-3 border-b border-b-border") do
      concat content_tag(:span, "Apps")
      concat content_tag(:span, "Enabled")
    end
  end

  # ===============================
  # 4️⃣ List Apps
  # ===============================
  def apps_list(apps)
    content_tag(:div, class: "flex flex-col kt-scrollable-y-auto max-h-[400px] divide-y divide-border") do
      safe_join(apps.map { |app| app_item(app) })
    end
  end

  def app_item(app)
    content_tag(:div, class: "flex items-center justify-between flex-wrap gap-2 px-5 py-3.5") do
      concat app_info(app)
      concat app_toggle(app)
    end
  end

  def app_info(app)
    content_tag(:div, class: "flex items-center flex-wrap gap-2") do
      concat(
        content_tag(:div, class: "flex items-center justify-center shrink-0 rounded-full bg-accent/60 border border-border size-10") do
          image_tag(app[:logo], alt: "", class: "size-6")
        end
      )
      concat(
        content_tag(:div, class: "flex flex-col") do
          concat(link_to(app[:name], app[:href] || "#", class: "text-sm font-semibold text-mono hover:text-primary"))
          concat(content_tag(:span, app[:description], class: "text-xs font-medium text-secondary-foreground"))
        end
      )
    end
  end

  def app_toggle(app)
    content_tag(:div, class: "flex items-center gap-2 lg:gap-5") do
      check_box_tag(app[:name].parameterize, "1", app[:enabled], class: "kt-switch")
    end
  end

  # ===============================
  # 5️⃣ Footer
  # ===============================
  def apps_dropdown_footer
    content_tag(:div, class: "grid p-5 border-t border-t-border") do
      link_to "Go to Apps", "/demo1/account/integrations.html", class: "kt-btn kt-btn-outline justify-center"
    end
  end
end
