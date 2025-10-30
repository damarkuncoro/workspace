module KT::ProjectsHelper
  def projects_card(title:, projects:)
    content_tag(:div, class: "kt-card") do
      concat(projects_card_header(title))
      concat(projects_table(projects))
      concat(projects_card_footer)
    end
  end

  private

  def projects_card_header(title)
    content_tag(:div, class: "kt-card-header") do
      concat content_tag(:h3, title, class: "kt-card-title")
      concat project_menu_dropdown
    end
  end

  def project_menu_dropdown
    content_tag(:div, class: "kt-menu", data: { kt_menu: true }) do
      content_tag(:div, class: "kt-menu-item", data: {
                    "kt-menu-item-toggle": "dropdown",
                    "kt-menu-item-trigger": "click",
                    "kt-menu-item-placement": "bottom-end"
                  }) do
        concat(
          button_tag(class: "kt-menu-toggle kt-btn kt-btn-sm kt-btn-icon kt-btn-ghost") do
            content_tag(:i, "", class: "ki-filled ki-dots-vertical text-lg")
          end
        )

        concat(
          content_tag(:div, class: "kt-menu-dropdown kt-menu-default w-full max-w-[175px]", data: { "kt-menu-dismiss": true }) do
            safe_join([
              project_menu_item("Add", "/demo1/account/home/settings-plain.html", "ki-add-files"),
              project_menu_item("Import", "/demo1/account/members/import-members.html", "ki-file-down"),
              project_export_submenu,
              project_menu_item("Settings", "/demo1/account/security/privacy-settings.html", "ki-setting-3")
            ])
          end
        )
      end
    end
  end

  def project_menu_item(title, href, icon)
    content_tag(:div, class: "kt-menu-item") do
      link_to(href, class: "kt-menu-link") do
        concat content_tag(:span, content_tag(:i, "", class: "ki-filled #{icon}"), class: "kt-menu-icon")
        concat content_tag(:span, title, class: "kt-menu-title")
      end
    end
  end

  def project_export_submenu
    content_tag(:div, class: "kt-menu-item", data: {
                  "kt-menu-item-toggle": "dropdown",
                  "kt-menu-item-trigger": "click|lg:hover",
                  "kt-menu-item-placement": "right-start"
                }) do
      concat(
        content_tag(:div, class: "kt-menu-link") do
          concat content_tag(:span, content_tag(:i, "", class: "ki-filled ki-file-up"), class: "kt-menu-icon")
          concat content_tag(:span, "Export", class: "kt-menu-title")
          concat content_tag(:span, content_tag(:i, "", class: "ki-filled ki-right text-xs rtl:transform rtl:rotate-180"), class: "kt-menu-arrow")
        end
      )

      concat(
        content_tag(:div, class: "kt-menu-dropdown kt-menu-default w-full max-w-[125px]") do
          safe_join([
            project_menu_item("PDF", "#", "ki-file-up"),
            project_menu_item("CSV", "#", "ki-file-up"),
            project_menu_item("Excel", "#", "ki-file-up")
          ])
        end
      )
    end
  end

  def projects_table(projects)
    content_tag(:div, class: "kt-card-table kt-scrollable-x-auto") do
      content_tag(:table, class: "kt-table table-fixed") do
        concat(projects_table_header)
        concat(
          content_tag(:tbody) do
            safe_join(projects.map { |p| project_row(p) })
          end
        )
      end
    end
  end

  def projects_table_header
    content_tag(:thead) do
      content_tag(:tr) do
        safe_join([
          content_tag(:th, "Project Name", class: "text-start w-52"),
          content_tag(:th, "Progress", class: "w-56 text-end"),
          content_tag(:th, "People", class: "w-36 text-end"),
          content_tag(:th, "Due Date", class: "w-36 text-end"),
          content_tag(:th, "", class: "w-16")
        ])
      end
    end
  end

  def project_row(p)
    content_tag(:tr) do
      safe_join([
        content_tag(:td, link_to(p[:name], "#", class: "text-sm font-medium text-mono hover:text-primary"), class: "text-start"),
        content_tag(:td, progress_bar(p[:progress], p[:progress_class])),
        content_tag(:td, project_people(p[:people])),
        content_tag(:td, p[:due_date], class: "text-sm font-medium text-secondary-foreground text-end"),
        content_tag(:td, project_actions, class: "text-start")
      ])
    end
  end

  def progress_bar(percent, style)
    content_tag(:div, class: "kt-progress #{style} h-[4px]") do
      content_tag(:div, "", class: "kt-progress-indicator", style: "width: #{percent}%")
    end
  end

  def project_people(avatars)
    content_tag(:div, class: "flex justify-end shrink-0") do
      content_tag(:div, class: "flex -space-x-2") do
        safe_join(
          avatars.map do |avatar|
            if avatar[:type] == :image
              image_tag(avatar[:src], class: "hover:z-5 relative shrink-0 rounded-full ring-1 ring-background size-6")
            else
              content_tag(:span, avatar[:text], class: "relative inline-flex items-center justify-center shrink-0 rounded-full ring-1 font-semibold leading-none text-2xs size-6 text-white ring-background #{avatar[:bg]}")
            end
          end
        )
      end
    end
  end

  def project_actions
    content_tag(:div, class: "kt-menu", data: { kt_menu: true }) do
      content_tag(:div, class: "kt-menu-item", data: {
                    "kt-menu-item-toggle": "dropdown",
                    "kt-menu-item-trigger": "click",
                    "kt-menu-item-placement": "bottom-end"
                  }) do
        concat(
          button_tag(class: "kt-menu-toggle kt-btn kt-btn-sm kt-btn-icon kt-btn-ghost") do
            content_tag(:i, "", class: "ki-filled ki-dots-vertical text-lg")
          end
        )

        concat(
          content_tag(:div, class: "kt-menu-dropdown kt-menu-default w-full max-w-[175px]", data: { "kt-menu-dismiss": true }) do
            safe_join([
              project_menu_item("View", "#", "ki-search-list"),
              project_menu_item("Export", "#", "ki-file-up"),
              content_tag(:div, "", class: "kt-menu-separator"),
              project_menu_item("Edit", "#", "ki-pencil"),
              project_menu_item("Make a copy", "#", "ki-copy"),
              content_tag(:div, "", class: "kt-menu-separator"),
              project_menu_item("Remove", "#", "ki-trash")
            ])
          end
        )
      end
    end
  end

  def projects_card_footer
    content_tag(:div, class: "kt-card-footer justify-center") do
      link_to("All Projects", "/demo1/public-profile/projects/3-columns.html", class: "kt-link kt-link-underlined kt-link-dashed")
    end
  end
end
