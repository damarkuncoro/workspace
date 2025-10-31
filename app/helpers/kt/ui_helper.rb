module KT::UiHelper
  include KT::BaseUiHelper
  include KT::BaseMenuHelper

  # ===============================
  # 🔹 ENHANCED UI COMPONENTS
  # ===============================

  # ✅ SRP: Enhanced card container - using card_builder
  def ui_card(title:, body:, footer: nil, menu: nil)
    card_builder(type: :standard, title: title, header_actions: menu ? [menu] : nil) do
      content_tag(:div, body, class: "kt-card-body")
    end
  end

  # ✅ SRP: Enhanced dropdown menu - using base menu helpers
  def ui_menu(button_icon:, items:)
    menu_wrapper do
      menu_item_wrapper(data_attrs: {
        "kt-menu-item-toggle": "dropdown",
        "kt-menu-item-trigger": "click",
        "kt-menu-item-placement": "bottom-end"
      }) do
        concat ui_button(icon: button_icon, variant: :ghost, size: :sm, button_class: "kt-menu-toggle kt-btn-icon")
        concat menu_dropdown(data_attrs: { "kt-menu-dismiss": true }, class: "kt-menu-default w-full max-w-[175px]") do
          safe_join(items.map { |item| build_menu_item(item) })
        end
      end
    end
  end

  # ✅ SRP: Enhanced table generator - using base UI table
  def ui_table(headers:, rows: [], &block)
    content_tag(:div, class: "kt-card-table kt-scrollable-x-auto") do
      ui_table(headers: headers.map { |h| { title: h[:title] || h, class: h[:class] } }, rows: rows) do |row|
        capture(row, &block)
      end
    end
  end

  # ✅ SRP: Enhanced info card - using card_builder
  def ui_info_card(title:, items:)
    card_builder(type: :standard, title: title) do
      ui_info_table(items)
    end
  end

  # ===============================
  # 🔹 ADDITIONAL UI COMPONENTS
  # ===============================

  # ✅ SRP: Form input wrapper
  def ui_form_group(label:, input:, error: nil, help: nil)
    content_tag(:div, class: "form-group") do
      concat content_tag(:label, label, class: "form-label") if label
      concat input
      concat content_tag(:div, error, class: "form-error") if error
      concat content_tag(:div, help, class: "form-help") if help
    end
  end

  # ✅ SRP: Status badge with variants
  def ui_status_badge(status:, text: nil)
    text ||= status.to_s.humanize
    type = case status.to_sym
           when :active, :success, :completed then :success
           when :inactive, :error, :failed then :danger
           when :pending, :warning then :warning
           else :default
           end
    ui_badge(text: text, type: type, size: :sm, outline: true)
  end

  # ✅ SRP: Loading spinner
  def ui_spinner(size: :md, color: :primary)
    size_class = case size
                 when :sm then "size-4"
                 when :lg then "size-8"
                 else "size-6"
                 end
    content_tag(:div, class: "animate-spin rounded-full border-2 border-#{color} border-t-transparent #{size_class}")
  end

  # ✅ SRP: Empty state component
  def ui_empty_state(icon:, title:, description: nil, action: nil)
    content_tag(:div, class: "text-center py-12") do
      concat ui_icon(icon_class: "ki-filled #{icon}", size: "text-6xl", icon_wrapper_class: "text-muted-foreground mb-4")
      concat content_tag(:h3, title, class: "text-lg font-semibold mb-2")
      concat content_tag(:p, description, class: "text-muted-foreground mb-4") if description
      concat action if action
    end
  end

  # ===============================
  # 🔹 PRIVATE HELPERS
  # ===============================
  private

  def build_menu_item(item)
    case item
    when :separator
      menu_separator
    when Hash
      menu_item_wrapper do
        menu_link(href: item[:href] || "#") do
          concat menu_icon(icon_class: "ki-filled #{item[:icon]}") if item[:icon]
          concat menu_title(title: item[:title])
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
