module KT
  module Features
    module ProjectsHelper
      include KT::UI::Base::BaseUIHelper
      include KT::UI::Base::BaseMenuHelper

      # ===============================
      # 🔹 MAIN PROJECT COMPONENTS
      # ===============================

      # ✅ SRP: Complete projects card
      def projects_card(title:, projects:)
        card_builder(type: :standard, title: title, header_actions: [ projects_menu_dropdown ]) do
          concat projects_table(projects)
          concat projects_card_footer
        end
      end

      # ===============================
      # 🔹 PRIVATE HELPERS
      # ===============================
      private

      # Projects menu dropdown - using base menu helpers
      def projects_menu_dropdown
        menu_wrapper do
          menu_item_wrapper(data_attrs: {
            "kt-menu-item-toggle": "dropdown",
            "kt-menu-item-trigger": "click",
            "kt-menu-item-placement": "bottom-end"
          }) do
            concat menu_dropdown_trigger_button
            concat projects_menu_content
          end
        end
      end

      # Menu trigger button
      def menu_dropdown_trigger_button
        ui_button(icon: "ki-dots-vertical", variant: :ghost, size: :sm, button_class: "kt-menu-toggle kt-btn-icon")
      end

      # Menu content
      def projects_menu_content
        menu_dropdown(data_attrs: { "kt-menu-dismiss": true }, class: "kt-menu-default w-full max-w-[175px]") do
          safe_join([
            projects_menu_item("Add", "/demo1/account/home/settings-plain.html", "ki-add-files"),
            projects_menu_item("Import", "/demo1/account/members/import-members.html", "ki-file-down"),
            projects_export_submenu,
            projects_menu_item("Settings", "/demo1/account/security/privacy-settings.html", "ki-setting-3")
          ])
        end
      end

      # Individual menu item
      def projects_menu_item(title, href, icon)
        menu_item_wrapper do
          menu_link(href: href) do
            concat menu_icon(icon_class: "ki-filled #{icon}")
            concat menu_title(title: title)
          end
        end
      end

      # Export submenu
      def projects_export_submenu
        menu_item_wrapper(data_attrs: {
          "kt-menu-item-toggle": "dropdown",
          "kt-menu-item-trigger": "click|lg:hover",
          "kt-menu-item-placement": "right-start"
        }) do
          concat submenu_trigger
          concat submenu_content
        end
      end

      # Submenu trigger
      def submenu_trigger
        content_tag(:div, class: "kt-menu-link") do
          concat menu_icon(icon_class: "ki-filled ki-file-up")
          concat menu_title(title: "Export")
          concat menu_arrow
        end
      end

      # Submenu content
      def submenu_content
        menu_dropdown(class: "kt-menu-default w-full max-w-[125px]") do
          safe_join([
            projects_menu_item("PDF", "#", "ki-file-up"),
            projects_menu_item("CSV", "#", "ki-file-up"),
            projects_menu_item("Excel", "#", "ki-file-up")
          ])
        end
      end

      # Projects table - using base UI table
      def projects_table(projects)
        content_tag(:div, class: "kt-card-table kt-scrollable-x-auto") do
          ui_table(
            headers: projects_table_headers,
            rows: projects.map { |p| project_row_data(p) },
            table_class: "kt-table table-fixed"
          )
        end
      end

      # Table headers
      def projects_table_headers
        [
          { title: "Project Name", class: "text-start w-52" },
          { title: "Progress", class: "w-56 text-end" },
          { title: "People", class: "w-36 text-end" },
          { title: "Due Date", class: "w-36 text-end" },
          { title: "", class: "w-16" }
        ]
      end

      # Project row data
      def project_row_data(project)
        [
          project_name_cell(project),
          progress_bar(project[:progress], project[:progress_class]),
          project_people(project[:people]),
          project_due_date(project[:due_date]),
          project_actions
        ]
      end

      # Project name cell
      def project_name_cell(project)
        link_to(project[:name], "#", class: "text-sm font-medium text-mono hover:text-primary")
      end

      # Progress bar - using base UI progress
      def progress_bar(percent, style_class)
        ui_progress(value: percent, progress_class: "kt-progress #{style_class} h-[4px]")
      end

      # Project people avatars
      def project_people(avatars)
        content_tag(:div, class: "flex justify-end shrink-0") do
          content_tag(:div, class: "flex -space-x-2") do
            safe_join(avatars.map { |avatar| render_project_avatar(avatar) })
          end
        end
      end

      # Render individual avatar
      def render_project_avatar(avatar)
        if avatar[:type] == :image
          ui_avatar(src: avatar[:src], size: "size-6", avatar_class: "hover:z-5 relative shrink-0 rounded-full ring-1 ring-background")
        else
          content_tag(:span, avatar[:text], class: "relative inline-flex items-center justify-center shrink-0 rounded-full ring-1 font-semibold leading-none text-2xs size-6 text-white ring-background #{avatar[:bg]}")
        end
      end

      # Project due date
      def project_due_date(date)
        content_tag(:span, date, class: "text-sm font-medium text-secondary-foreground")
      end

      # Project actions menu
      def project_actions
        menu_wrapper do
          menu_item_wrapper(data_attrs: {
            "kt-menu-item-toggle": "dropdown",
            "kt-menu-item-trigger": "click",
            "kt-menu-item-placement": "bottom-end"
          }) do
            concat menu_dropdown_trigger_button
            concat project_actions_menu_content
          end
        end
      end

      # Project actions menu content
      def project_actions_menu_content
        menu_dropdown(data_attrs: { "kt-menu-dismiss": true }, class: "kt-menu-default w-full max-w-[175px]") do
          safe_join([
            projects_menu_item("View", "#", "ki-search-list"),
            projects_menu_item("Export", "#", "ki-file-up"),
            menu_separator,
            projects_menu_item("Edit", "#", "ki-pencil"),
            projects_menu_item("Make a copy", "#", "ki-copy"),
            menu_separator,
            projects_menu_item("Remove", "#", "ki-trash")
          ])
        end
      end

      # Projects card footer
      def projects_card_footer
        content_tag(:div, class: "kt-card-footer justify-center") do
          ui_link(text: "All Projects", href: "/demo1/public-profile/projects/3-columns.html", underlined: true, dashed: true)
        end
      end
    end
  end
end
