# app/helpers/kt/features/profile_menu_helper.rb
module KT
  module Features
    module ProfileMenuHelper
      # ===============================
      # 1️⃣ Wrapper utama profile menu
      # ===============================
      def profile_menu_container(menu:, actions:)
        content_tag(:div, class: "kt-container-fixed") do
          content_tag(:div,
            class: "flex items-center flex-wrap md:flex-nowrap lg:items-end justify-between border-b border-b-border gap-3 lg:gap-6 mb-5 lg:mb-10"
          ) do
            concat profile_menu(menu)
            concat profile_actions(actions)
          end
        end
      end

      # ===============================
      # 2️⃣ Menu bagian kiri (Profiles, Projects, Works, dst)
      # ===============================
      def profile_menu(menu_items)
        content_tag(:div, class: "grid") do
          content_tag(:div, class: "kt-scrollable-x-auto") do
            content_tag(:div, class: "kt-menu gap-3", data: { "kt-menu": true }) do
              safe_join(menu_items.map { |item| profile_menu_item(item) })
            end
          end
        end
      end

      # ===============================
      # 3️⃣ Item menu (dengan/ tanpa dropdown)
      # ===============================
      def profile_menu_item(item)
        classes = "kt-menu-item border-b-2 border-b-transparent " \
                  "kt-menu-item-active:border-b-primary kt-menu-item-here:border-b-primary"
        data = {
          "kt-menu-item-overflow": true,
          "kt-menu-item-toggle": item[:submenu] ? "dropdown" : nil,
          "kt-menu-item-trigger": item[:submenu] ? "click|lg:hover" : nil,
          "kt-menu-item-placement": "bottom-start",
          "kt-menu-item-placement-rtl": "bottom-end"
        }.compact

        content_tag(:div, class: classes, data: data) do
          if item[:submenu]
            concat(profile_menu_with_dropdown(item))
          else
            concat(link_to(item[:href], class: "kt-menu-link gap-1.5 pb-2 lg:pb-4 px-2") do
              content_tag(:span, item[:title],
                          class: "kt-menu-title text-nowrap font-medium text-sm text-secondary-foreground " \
                                 "kt-menu-link-hover:text-primary kt-menu-item-active:text-primary")
            end)
          end
        end
      end

      # ===============================
      # 4️⃣ Item menu dengan dropdown
      # ===============================
      def profile_menu_with_dropdown(item)
        capture do
          concat(
            content_tag(:div, class: "kt-menu-link gap-1.5 pb-2 lg:pb-4 px-2", tabindex: 0) do
              concat content_tag(:span, item[:title],
                class: "kt-menu-title text-nowrap text-sm text-secondary-foreground kt-menu-link-hover:text-primary kt-menu-item-active:text-primary"
              )
              concat content_tag(:span,
                content_tag(:i, "", class: "ki-filled ki-down text-xs text-muted-foreground"),
                class: "kt-menu-arrow"
              )
            end
          )

          concat(
            content_tag(:div, class: "kt-menu-dropdown kt-menu-default py-2 min-w-[200px]") do
              safe_join(item[:submenu].map do |sub|
                content_tag(:div, class: "kt-menu-item") do
                  link_to(sub[:href], class: "kt-menu-link") do
                    content_tag(:span, sub[:title], class: "kt-menu-title")
                  end
                end
              end)
            end
          )
        end
      end

      # ===============================
      # 5️⃣ Tombol aksi (Connect, Chat, Dropdown)
      # ===============================
      def profile_actions(actions)
        content_tag(:div, class: "flex items-center justify-end grow lg:grow-0 lg:pb-4 gap-2.5 mb-3 lg:mb-0") do
          concat(profile_action_button(actions[:connect]))
          concat(profile_action_icon(actions[:message]))
          concat(profile_action_dropdown(actions[:more]))
        end
      end

      # ===============================
      # 6️⃣ Tombol utama: Connect
      # ===============================
      def profile_action_button(button)
        return unless button

        button_tag(class: "kt-btn kt-btn-primary") do
          concat content_tag(:i, "", class: "ki-filled #{button[:icon]}")
          concat " #{button[:label]}"
        end
      end

      # ===============================
      # 7️⃣ Tombol icon tunggal (Chat)
      # ===============================
      def profile_action_icon(icon)
        return unless icon

        button_tag(class: "kt-btn kt-btn-icon kt-btn-outline") do
          content_tag(:i, "", class: "ki-filled #{icon[:icon]}")
        end
      end

      # ===============================
      # 8️⃣ Dropdown More
      # ===============================
      def profile_action_dropdown(dropdown)
        return unless dropdown

        content_tag(:div, data: {
          "kt-dropdown": true,
          "kt-dropdown-placement": "bottom-end",
          "kt-dropdown-trigger": "click"
        }) do
          concat(
            button_tag(class: "kt-dropdown-toggle kt-btn kt-btn-icon kt-btn-outline",
                       data: { "kt-dropdown-toggle": true }) do
              content_tag(:i, "", class: "ki-filled #{dropdown[:icon]}")
            end
          )
          concat(
            content_tag(:div, class: "kt-dropdown-menu w-full max-w-[220px]", data: { "kt-dropdown-menu": true }) do
              content_tag(:ul, class: "kt-dropdown-menu-sub") do
                safe_join(dropdown[:items].map { |item| profile_action_dropdown_item(item) })
              end
            end
          )
        end
      end

      # ===============================
      # 9️⃣ Item dropdown More
      # ===============================
      def profile_action_dropdown_item(item)
        content_tag(:li) do
          if item[:switch]
            content_tag(:div, class: "kt-dropdown-menu-link") do
              concat(content_tag(:i, "", class: "ki-filled #{item[:icon]}"))
              concat(" #{item[:label]}")
              concat(check_box_tag(:check, "1", item[:checked], class: "ms-auto kt-switch kt-switch-sm"))
            end
          else
            button_tag(class: "kt-dropdown-menu-link",
                       data: item[:data] || {}) do
              concat(content_tag(:i, "", class: "ki-filled #{item[:icon]}"))
              concat(" #{item[:label]}")
            end
          end
        end
      end
    end
  end
end
