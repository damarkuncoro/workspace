module KT::Profile::UploadsHelper
  # File Uploads Card
  def file_uploads_card(files: [])
    content_tag(:div, class: "kt-card") do
      concat(content_tag(:div, class: "kt-card-header") do
        content_tag(:h3, "Recent Uploads", class: "kt-card-title")
      end)
      concat(content_tag(:div, class: "kt-card-content") do
        content_tag(:div, class: "grid gap-2.5 lg:gap-5") do
          safe_join([
            file_upload_item(
              icon: "/assets/media/file-types/pdf.svg",
              name: "Project-pitch.pdf",
              size: "4.7 MB",
              date: "26 Sep 2024 3:20 PM"
            ),
            file_upload_item(
              icon: "/assets/media/file-types/doc.svg",
              name: "Report-v1.docx",
              size: "2.3 MB",
              date: "1 Oct 2024 12:00 PM"
            ),
            file_upload_item(
              icon: "/assets/media/file-types/ai.svg",
              name: "Framework-App.js",
              size: "0.8 MB",
              date: "17 Oct 2024 6:46 PM"
            ),
            file_upload_item(
              icon: "/assets/media/file-types/js.svg",
              name: "Mobile-logo.ai",
              size: "0.2 MB",
              date: "4 Nov 2024 11:30 AM"
            )
          ])
        end
      end)
      concat(content_tag(:div, class: "kt-card-footer justify-center") do
        link_to("All Files", "/demo1/account/integrations.html", class: "kt-link kt-link-underlined kt-link-dashed")
      end)
    end
  end

  private

  def file_upload_item(icon:, name:, size:, date:)
    content_tag(:div, class: "flex items-center gap-3") do
      concat(content_tag(:div, class: "flex items-center grow gap-2.5") do
        concat(image_tag(icon))
        concat(content_tag(:div, class: "flex flex-col") do
          concat(content_tag(:span, name, class: "text-sm font-medium text-mono cursor-pointer hover:text-primary mb-px"))
          concat(content_tag(:span, "#{size} #{date}", class: "text-xs text-secondary-foreground"))
        end)
      end)
      concat(file_menu)
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