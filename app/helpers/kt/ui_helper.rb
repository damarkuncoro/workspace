module KT::UiHelper
  # Generic card container
  def ui_card(title:, body:, footer: nil, menu: nil)
    content_tag(:div, class: "kt-card") do
      concat(
        content_tag(:div, class: "kt-card-header") do
          concat content_tag(:h3, title, class: "kt-card-title")
          concat(menu) if menu
        end
      )
      concat(content_tag(:div, body, class: "kt-card-body"))
      concat(content_tag(:div, footer, class: "kt-card-footer justify-center")) if footer
    end
  end

  # Generic dropdown menu
  def ui_menu(button_icon:, items:)
    content_tag(:div, class: "kt-menu", data: { kt_menu: true }) do
      content_tag(:div, class: "kt-menu-item", data: {
                    "kt-menu-item-toggle": "dropdown",
                    "kt-menu-item-trigger": "click",
                    "kt-menu-item-placement": "bottom-end"
                  }) do
        concat(
          button_tag(class: "kt-menu-toggle kt-btn kt-btn-sm kt-btn-icon kt-btn-ghost") do
            content_tag(:i, "", class: "ki-filled #{button_icon} text-lg")
          end
        )

        concat(
          content_tag(:div, class: "kt-menu-dropdown kt-menu-default w-full max-w-[175px]", data: { "kt-menu-dismiss": true }) do
            safe_join(items.map { |item| build_menu_item(item) })
          end
        )
      end
    end
  end

  # Generic table generator
  def ui_table(headers:, rows: [], &block)
  content_tag(:div, class: "kt-card-table kt-scrollable-x-auto") do
    content_tag(:table, class: "kt-table table-fixed") do
      concat(
        content_tag(:thead) do
          content_tag(:tr) do
            safe_join(headers.map { |h| content_tag(:th, h[:title], class: h[:class]) })
          end
        end
      )

      concat(
        content_tag(:tbody) do
          safe_join(Array(rows).map { |row| capture(row, &block) })
        end
      )
      end
    end
  end

   def ui_info_card(title:, items:)
    content_tag(:div, class: "kt-card") do
      safe_join([
        ui_card_header(title),
        ui_info_table(items)
      ])
    end
  end

  private

  def build_menu_item(item)
    case item
    when :separator
      content_tag(:div, "", class: "kt-menu-separator")
    when Hash
      content_tag(:div, class: "kt-menu-item") do
        link_to(item[:href] || "#", class: "kt-menu-link") do
          concat content_tag(:span, content_tag(:i, "", class: "ki-filled #{item[:icon]}"), class: "kt-menu-icon") if item[:icon]
          concat content_tag(:span, item[:title], class: "kt-menu-title")
        end
      end
    else
      ""
    end
  end


  # Card Header (Single Responsibility)
  def ui_card_header(title)
    content_tag(:div, class: "kt-card-header") do
      content_tag(:h3, title, class: "kt-card-title")
    end
  end

  # Info Table (DRY rendering of key-value pairs)
  def ui_info_table(items)
    content_tag(:div, class: "kt-card-content pt-4 pb-3") do
      content_tag(:table, class: "kt-table-auto") do
        content_tag(:tbody) do
          safe_join(items.map { |label, value| ui_info_row(label, value) })
        end
      end
    end
  end

  # Row Component — SRP: one responsibility, one row
  def ui_info_row(label, value)
    content_tag(:tr) do
      safe_join([
        content_tag(:td, label, class: "text-sm text-secondary-foreground pb-3.5 pe-3"),
        content_tag(:td, value, class: "text-sm text-mono pb-3.5")
      ])
    end
  end
  
end
