module KT
  module TopbarHelper
    # Topbar User - komponen dropdown user di header
    #
    # Tujuan:
    # - Menyediakan API dinamis, reusable, dan DRY untuk topbar user
    # - Mengikuti pola helper (**args, &block) yang konsisten dengan KT helpers
    # - Mendukung kustomisasi menu melalui block
    #
    # Argumen:
    # - avatar_src: path avatar (String)
    # - name: nama pengguna (String)
    # - email: email pengguna (String)
    # - badge_text: teks badge (String, opsional)
    # - dropdown_width: lebar dropdown (String, mis. "w-[250px]")
    # - container_class: kelas tambahan untuk container luar
    # - trigger: jenis trigger dropdown (default: "click")
    #
    # Block:
    # - Bila diberikan, block akan digunakan untuk mengisi isi menu (ul.kt-dropdown-menu-sub)
    def kt_topbar_user(**args, &block)
      options = {
        avatar_src: "/assets/media/avatars/300-2.png",
        name: "Cody Fisher",
        email: "c.fisher@gmail.com",
        badge_text: "Pro",
        dropdown_width: "w-[250px]",
        container_class: "shrink-0",
        trigger: "click"
      }.merge(args)

      content_tag(:div,
        class: options[:container_class],
        data: {
          "kt-dropdown" => true,
          "kt-dropdown-offset" => "10px, 10px",
          "kt-dropdown-offset-rtl" => "-20px, 10px",
          "kt-dropdown-placement" => "bottom-end",
          "kt-dropdown-placement-rtl" => "bottom-start",
          "kt-dropdown-trigger" => options[:trigger]
        }
      ) do
        safe_join([
          # Toggle (avatar)
          content_tag(:div, class: "cursor-pointer shrink-0", data: { "kt-dropdown-toggle" => true }) do
            image_tag(options[:avatar_src], alt: "", class: "size-9 rounded-full border-2 border-green-500 shrink-0")
          end,

          # Dropdown menu
          kt_topbar_dropdown(width_class: options[:dropdown_width]) do
            safe_join([
              # Header info (avatar + name + email + badge)
              content_tag(:div, class: "flex items-center justify-between px-2.5 py-1.5 gap-1.5") do
                safe_join([
                  content_tag(:div, class: "flex items-center gap-2") do
                    safe_join([
                      image_tag(options[:avatar_src], alt: "", class: "size-9 shrink-0 rounded-full border-2 border-green-500"),
                      content_tag(:div, class: "flex flex-col gap-1.5") do
                        safe_join([
                          content_tag(:span, options[:name], class: "text-sm text-foreground font-semibold leading-none"),
                          link_to(options[:email], "/demo1/account/home/get-started.html", class: "text-xs text-secondary-foreground hover:text-primary font-medium leading-none")
                        ])
                      end
                    ])
                  end,
                  (content_tag(:span, options[:badge_text], class: "kt-badge kt-badge-sm kt-badge-primary kt-badge-outline") if options[:badge_text].present?)
                ].compact)
              end,

              # Sub menu (ul)
              content_tag(:ul, class: "kt-dropdown-menu-sub") do
                if block_given?
                  capture(&block)
                else
                  # Default isi menu bila block tidak diberikan
                  safe_join([
                    kt_topbar_separator_li,
                    kt_topbar_link_li(title: "Public Profile", href: "/demo1/public-profile/profiles/default.html", icon: "ki-badge"),
                    kt_topbar_link_li(title: "My Profile", href: "/demo1/account/home/user-profile.html", icon: "ki-profile-circle"),
                    # Submenu: My Account
                    kt_topbar_submenu_li(title: "My Account", icon: "ki-setting-2") do
                      safe_join([
                        kt_topbar_link_li(title: "Get Started", href: "/demo1/account/home/get-started.html", icon: "ki-coffee"),
                        kt_topbar_link_li(title: "My Profile", href: "/demo1/account/home/user-profile.html", icon: "ki-some-files"),
                        kt_topbar_link_li(title: "Billing", href: "#", icon: "ki-icon") do
                          # Right-side extra (tooltip)
                          content_tag(:span, class: "ms-auto inline-flex items-center", data: { "kt-tooltip" => true, "kt-tooltip-placement" => "top" }) do
                            safe_join([
                              content_tag(:i, "", class: "ki-filled ki-information-2 text-base text-muted-foreground"),
                              content_tag(:span, "Payment and subscription info", class: "kt-tooltip", data: { "kt-tooltip-content" => true })
                            ])
                          end
                        end,
                        kt_topbar_link_li(title: "Security", href: "/demo1/account/security/overview.html", icon: "ki-medal-star"),
                        kt_topbar_link_li(title: "Members & Roles", href: "/demo1/account/members/teams.html", icon: "ki-setting"),
                        kt_topbar_link_li(title: "Integrations", href: "/demo1/account/integrations.html", icon: "ki-switch"),
                        kt_topbar_separator_li,
                        kt_topbar_link_li(title: "Notifications", href: "/demo1/account/security/overview.html", icon: "ki-shield-tick") do
                          # Right-side toggle (switch)
                          tag.input(class: "ms-auto kt-switch", type: "checkbox", name: "check", value: "1", checked: true)
                        end
                      ])
                    end,
                    kt_topbar_link_li(title: "Dev Forum", href: "https://devs.keenthemes.com", icon: "ki-message-programming"),
                    # Language submenu
                    kt_topbar_submenu_li(title: "Language", icon: "ki-icon", toggle_class: "py-1") do
                      content_tag(:ul, class: "kt-dropdown-menu-sub") do
                        safe_join([
                          kt_topbar_language_li(title: "English", flag_src: "/assets/media/flags/united-states.svg", active: true, href: "?dir=ltr"),
                          kt_topbar_language_li(title: "Arabic(Saudi)", flag_src: "/assets/media/flags/saudi-arabia.svg", href: "?dir=rtl"),
                          kt_topbar_language_li(title: "Spanish", flag_src: "/assets/media/flags/spain.svg", href: "?dir=ltr"),
                          kt_topbar_language_li(title: "German", flag_src: "/assets/media/flags/germany.svg", href: "?dir=ltr"),
                          kt_topbar_language_li(title: "Japanese", flag_src: "/assets/media/flags/japan.svg", href: "?dir=ltr")
                        ])
                      end
                    end,
                    kt_topbar_separator_li
                  ])
                end
              end,

              # Bottom actions (dark mode + logout)
              content_tag(:div, class: "px-2.5 pt-1.5 mb-2.5 flex flex-col gap-3.5") do
                safe_join([
                  content_tag(:div, class: "flex items-center gap-2 justify-between") do
                    safe_join([
                      content_tag(:span, class: "flex items-center gap-2") do
                        safe_join([
                          content_tag(:i, "", class: "ki-filled ki-moon text-base text-muted-foreground"),
                          content_tag(:span, "Dark Mode", class: "font-medium text-2sm")
                        ])
                      end,
                      tag.input(class: "kt-switch", type: "checkbox", name: "check", value: "1", data: { "kt-theme-switch-toggle" => true, "kt-theme-switch-state" => "dark" })
                    ])
                  end,
                  button_to("Log out", destroy_account_session_path, method: :delete, class: "kt-btn kt-btn-outline justify-center w-full")
                ])
              end
            ])
          end
        ])
      end
    end

    # Dropdown container (div.kt-dropdown-menu) dengan lebar opsional
    # - Memudahkan reuse di komponen topbar lain
    def kt_topbar_dropdown(**args, &block)
      options = {
        width_class: "w-[250px]",
        data_attrs: { "kt-dropdown-menu" => true },
        tag: :div
      }.merge(args)

      classes = ["kt-dropdown-menu", options[:width_class]].compact.join(" ")

      content_tag(options[:tag], class: classes, data: options[:data_attrs]) do
        block_given? ? capture(&block) : ""
      end
    end

    # Item link standar di dalam ul.kt-dropdown-menu-sub
    # - Mendukung icon kiri dan konten kanan tambahan via block
    # Catatan: Hindari modifier `if` langsung di dalam array literal untuk mencegah SyntaxError.
    #          Gunakan variabel sementara (icon_tag) lalu `.compact` ketika melakukan `safe_join`.
    def kt_topbar_link_li(**args, &block)
      options = {
        title: nil,
        href: "#",
        icon: nil
      }.merge(args)

      content_tag(:li) do
        link_classes = "kt-dropdown-menu-link"
        link_attrs = { href: options[:href], class: link_classes }

        content_tag(:a, link_attrs) do
          # Bangun icon_tag secara aman; hindari `if` modifier di dalam array literal
          icon_tag = options[:icon] ? content_tag(:i, "", class: "ki-filled #{options[:icon]}") : nil

          left = content_tag(:span, class: "flex items-center gap-2") do
            safe_join([
              icon_tag,
              options[:title]
            ].compact)
          end

          right = block_given? ? capture(&block) : nil

          safe_join([left, right].compact)
        end
      end
    end

    # Separator li
    def kt_topbar_separator_li
      content_tag(:li) do
        content_tag(:div, "", class: "kt-dropdown-menu-separator")
      end
    end

    # Submenu li (hover/click)
    # - title + icon + indicator panah kanan
    # - block: isi dropdown submenu
    def kt_topbar_submenu_li(**args, &block)
      options = {
        title: nil,
        icon: nil,
        toggle_class: nil,
        trigger: "hover",
        placement: "right-start"
      }.merge(args)

      content_tag(:li, data: { "kt-dropdown" => true, "kt-dropdown-placement" => options[:placement], "kt-dropdown-trigger" => options[:trigger] }) do
        safe_join([
          content_tag(:button, class: ["kt-dropdown-menu-toggle", options[:toggle_class]].compact.join(" "), data: { "kt-dropdown-toggle" => true }) do
            safe_join([
              begin
                icon_tag = options[:icon] ? content_tag(:i, "", class: "ki-filled #{options[:icon]}") : nil
                content_tag(:span, class: "flex items-center gap-2") do
                  safe_join([
                    icon_tag,
                    options[:title]
                  ].compact)
                end
              end,
              content_tag(:span, class: "kt-dropdown-menu-indicator") do
                content_tag(:i, "", class: "ki-filled ki-right text-xs")
              end
            ])
          end,
          content_tag(:div, class: "kt-dropdown-menu w-[220px]", data: { "kt-dropdown-menu" => true }) do
            block_given? ? capture(&block) : ""
          end
        ])
      end
    end

    # Language item (li) dengan flag, title, dan optional active state
    def kt_topbar_language_li(**args)
      options = {
        title: nil,
        flag_src: nil,
        href: "#",
        active: false
      }.merge(args)

      li_classes = options[:active] ? "active" : ""

      content_tag(:li, class: li_classes) do
        link_to(options[:href], class: "kt-dropdown-menu-link") do
          left = content_tag(:span, class: "flex items-center gap-2") do
            safe_join([
              image_tag(options[:flag_src], alt: "", class: "inline-block size-4 rounded-full"),
              content_tag(:span, options[:title], class: "kt-menu-title")
            ])
          end

          right = options[:active] ? content_tag(:i, "", class: "ki-solid ki-check-circle ms-auto text-green-500 text-base") : nil

          safe_join([left, right].compact)
        end
      end
    end
  end
end