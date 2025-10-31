# app/helpers/kt/profile/info_helper.rb
module KT::Profile::InfoHelper
  include KT::Card::CardHelper
  include KT::Card::HeaderHelper
  include KT::Card::BodyHelper
  include KT::Card::FooterHelper

  # ==========================================================
  # 🔹 PUBLIC INTERFACE
  # ==========================================================

  # ✅ Seksi informasi profil lengkap (gabungan person, customer, employee)
  def profile_info_section(account:, customer: nil, employee: nil)
    safe_join([
      build_info_block("Profile Info", build_personal_info(account.person)),
      (build_info_block("Customer Info", build_customer_info(customer)) if customer),
      (build_info_block("Employee Info", build_employee_info(employee)) if employee)
    ].compact)
  end

  # ✅ Kartu "Personal Info"
  def personal_info_card(person:)
    build_card("Personal Info") do
      build_table_body([
        info_row("Photo", "150x150px JPEG, PNG Image", build_photo_input),
        info_row("Name", person&.name || "Not provided", build_edit_button),
        info_row("Availability", badge("Available now", :success), build_edit_button),
        info_row("Birthday", format_date(person&.date_of_birth) || "Not set", build_edit_button),
        info_row("Gender", "Male", build_edit_button),
        info_row("Address", "You have no address yet", build_add_link("Add"))
      ])
    end
  end

  # ✅ Kartu "Basic Settings"
  def basic_settings_card(account:)
    build_card("Basic Settings", header_actions: toggle_switch("Public Profile")) do
      build_table_body([
        info_row("Email", link_to(account.email, "#", class: "text-foreground hover:text-primary"), build_edit_button),
        info_row("Password", "Changed 2 months ago", build_edit_button),
        info_row("2FA", "To be set", build_setup_link("Setup")),
        info_row("Sign-in with", build_signin_icons, build_edit_button),
        info_row("Team Account", "To be set", build_setup_link("Setup")),
        info_row("Social Profiles", build_social_icons, build_edit_button),
        info_row("Referral Link", build_referral_link, build_recreate_link("Re-create"))
      ])
    end
  end

  # ✅ Kartu "Work"
  def work_card
    build_card("Work", header_actions: toggle_switch("Available now")) do
      build_table_body([
        info_row("Language", "English - Fluent", build_edit_button),
        info_row("Hourly Rate", "$28 / hour", build_edit_button),
        info_row("Availability", "32 hours a week", build_edit_button),
        info_row("Skills", build_skills_badges, build_edit_button),
        info_row("About", "We're open to partnerships, guest posts, and more. Join us to share your insights and grow your audience.", build_edit_button)
      ])
    end
  end


  # ==========================================================
  # 🔹 PRIVATE HELPERS
  # ==========================================================
  private

  # ==========================================================
  # 🧩 Core Builders
  # ==========================================================
  def build_info_block(title, content)
    content_tag(:div, class: "mb-4") do
      concat(content_tag(:h3, title, class: "text-md font-semibold mb-2"))
      concat(content)
    end
  end

  def build_card(title, header_actions: nil, &block)
    full_card(title: title, header_actions: header_actions) do
      card_body(padding: "kt-card-table kt-scrollable-x-auto pb-3", &block)
    end
  end

  def build_table_body(rows)
    content_tag(:table, class: "kt-table align-middle text-sm text-muted-foreground") do
      content_tag(:tbody) { safe_join(rows) }
    end
  end


  # ==========================================================
  # 🧩 Generic Info Row
  # ==========================================================
  def info_row(label, value, action_cell = nil)
    content_tag(:tr) do
      concat(content_tag(:td, label, class: "py-2 min-w-36 text-secondary-foreground font-normal"))
      concat(content_tag(:td, value, class: "py-2 min-w-60 text-secondary-foreground font-normal"))
      concat(content_tag(:td, action_cell, class: "py-2 text-end min-w-16")) if action_cell
    end
  end


  # ==========================================================
  # 🧩 Sub Info Builders
  # ==========================================================
  def build_personal_info(person)
    safe_join([
      info_text("Name:", person&.name),
      info_text("Date of Birth:", format_date(person&.date_of_birth))
    ])
  end

  def build_customer_info(customer)
    safe_join([
      info_text("Customer Code:", customer.customer_code),
      info_text("Status:", customer.status),
      info_text("Registered At:", format_date(customer.created_at))
    ])
  end

  def build_employee_info(employee)
    safe_join([
      info_text("Employee Code:", employee.employee_code),
      info_text("Status:", employee.status),
      info_text("Registered At:", format_date(employee.created_at))
    ])
  end


  # ==========================================================
  # 🧩 UI Elements
  # ==========================================================
  def build_photo_input
    content_tag(:div, class: "flex justify-center items-center") do
      content_tag(:div, class: "kt-image-input size-16", data: { kt_image_input: true }) do
        safe_join([
          tag.input(type: "file", name: "avatar", accept: ".png,.jpg,.jpeg"),
          tag.input(type: "hidden", name: "avatar_remove"),
          content_tag(:div, "", class: "kt-image-input-placeholder border-2 border-green-500", style: "background-image:url(/static/metronic/tailwind/dist/assets/media/avatars/blank.png)")
        ])
      end
    end
  end

  def build_edit_button
    link_to("#", class: "kt-btn kt-btn-icon kt-btn-sm kt-btn-ghost kt-btn-primary") do
      tag.i("", class: "ki-filled ki-notepad-edit")
    end
  end

  def build_add_link(text)
    link_to(text, "#", class: "kt-link kt-link-underlined kt-link-dashed")
  end

  def build_setup_link(text)
    link_to(text, "#", class: "kt-link kt-link-underlined kt-link-dashed")
  end

  def build_recreate_link(text)
    link_to(text, "#", class: "kt-link kt-link-underlined kt-link-dashed")
  end

  def build_signin_icons
    build_icon_list([
      "/static/metronic/tailwind/dist/assets/media/brand-logos/google.svg",
      "/static/metronic/tailwind/dist/assets/media/brand-logos/facebook.svg",
      "/static/metronic/tailwind/dist/assets/media/brand-logos/apple-black.svg"
    ])
  end

  def build_social_icons
    build_icon_list([
      "/static/metronic/tailwind/dist/assets/media/brand-logos/linkedin.svg",
      "/static/metronic/tailwind/dist/assets/media/brand-logos/twitch-purple.svg",
      "/static/metronic/tailwind/dist/assets/media/brand-logos/x.svg",
      "/static/metronic/tailwind/dist/assets/media/brand-logos/dribbble.svg"
    ])
  end

  def build_icon_list(paths)
    content_tag(:div, class: "flex items-center gap-2.5") do
      safe_join(paths.map do |src|
        link_to("#", class: "flex items-center justify-center size-8 bg-background rounded-full border border-input") do
          tag.img(src: src, alt: "", class: "size-4")
        end
      end)
    end
  end

  def build_referral_link
    content_tag(:div, class: "flex items-center gap-1") do
      safe_join([
        link_to("https://studio.co/W3gvQOI35dt", "#", class: "text-foreground text-sm hover:text-primary"),
        link_to("#", class: "kt-btn kt-btn-sm kt-btn-ghost kt-btn-icon") do
          tag.i("", class: "ki-filled ki-copy text-muted-foreground text-sm")
        end
      ])
    end
  end

  def build_skills_badges
    badges = %w[Web\ Design Code\ Review noCode UX Figma Webflow AI Management]
    content_tag(:div, class: "flex flex-wrap gap-2.5") do
      safe_join(badges.map { |b| content_tag(:span, b, class: "kt-badge kt-badge-outline") })
    end
  end


  # ==========================================================
  # 🧩 Utilities
  # ==========================================================
  def info_text(label, value)
    content_tag(:p) do
      concat(content_tag(:strong, "#{label} "))
      concat(value.presence || "Not provided")
    end
  end

  def format_date(date)
    date ? l(date) : nil
  end

  def badge(text, type)
    content_tag(:span, text, class: "kt-badge kt-badge-sm kt-badge-outline kt-badge-#{type}")
  end

  def toggle_switch(label)
    content_tag(:label, class: "kt-label flex items-center gap-2") do
      safe_join([
        label,
        tag.input(type: "checkbox", class: "kt-switch kt-switch-sm", checked: true)
      ])
    end
  end
end
