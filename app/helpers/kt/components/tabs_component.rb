# app/helpers/kt/components/tabs_component.rb
module KT::Components::TabsComponent
  include KT::BaseUiHelper

  # ✅ SRP: Main tabs component
  def ui_tabs(tabs: [], active: 0, variant: :default, size: :md, orientation: :horizontal, **options)
    wrapper_class = orientation == :vertical ? "flex gap-4" : ""
    data_attrs = { "kt-tabs": true }

    content_tag(:div, class: wrapper_class, data: data_attrs, **options) do
      concat tabs_list(tabs, active, variant, size, orientation)
      concat tabs_content(tabs, active, orientation)
    end
  end

  # ✅ SRP: Tabs list (navigation)
  def tabs_list(tabs, active, variant, size, orientation)
    list_class = build_tabs_list_class(variant, size, orientation)

    content_tag(:div, class: list_class, role: "tablist") do
      content_tag(:div, class: orientation == :vertical ? "flex flex-col" : "flex") do
        safe_join(tabs.each_with_index.map { |tab, index| tab_item(tab, index, active, variant, size) })
      end
    end
  end

  # ✅ SRP: Individual tab item
  def tab_item(tab, index, active, variant, size)
    is_active = index == active
    item_class = build_tab_item_class(is_active, variant, size)

    button_tag(
      class: item_class,
      role: "tab",
      "aria-selected": is_active,
      "aria-controls": "tab-#{index}",
      "data-kt-tab": index,
      tabindex: is_active ? 0 : -1
    ) do
      concat ui_icon(name: tab[:icon], size: :sm) if tab[:icon]
      concat tab[:title]
      concat ui_badge(text: tab[:badge], size: :xs) if tab[:badge]
    end
  end

  # ✅ SRP: Tabs content area
  def tabs_content(tabs, active, orientation)
    content_class = orientation == :vertical ? "flex-1" : "mt-4"

    content_tag(:div, class: content_class) do
      safe_join(tabs.each_with_index.map { |tab, index| tab_panel(tab, index, active) })
    end
  end

  # ✅ SRP: Individual tab panel
  def tab_panel(tab, index, active)
    is_active = index == active
    panel_class = build_tab_panel_class(is_active)

    content_tag(:div,
      id: "tab-#{index}",
      class: panel_class,
      role: "tabpanel",
      "aria-labelledby": "tab-#{index}",
      tabindex: is_active ? 0 : -1
    ) do
      tab[:content]
    end
  end

  # ✅ SRP: Pills variant tabs
  def ui_tabs_pills(tabs: [], active: 0, **options)
    ui_tabs(tabs: tabs, active: active, variant: :pills, **options)
  end

  # ✅ SRP: Underline variant tabs
  def ui_tabs_underline(tabs: [], active: 0, **options)
    ui_tabs(tabs: tabs, active: active, variant: :underline, **options)
  end

  # ✅ SRP: Vertical tabs
  def ui_tabs_vertical(tabs: [], active: 0, **options)
    ui_tabs(tabs: tabs, active: active, orientation: :vertical, **options)
  end

  private

  def build_tabs_list_class(variant, size, orientation)
    classes = ["kt-tabs"]

    # Variant
    case variant
    when :pills then classes << "kt-tabs-pills"
    when :underline then classes << "kt-tabs-underline"
    else classes << "kt-tabs-default"
    end

    # Size
    case size
    when :sm then classes << "kt-tabs-sm"
    when :lg then classes << "kt-tabs-lg"
    else classes << "kt-tabs-md"
    end

    # Orientation
    classes << "kt-tabs-vertical" if orientation == :vertical

    classes.join(" ")
  end

  def build_tab_item_class(is_active, variant, size)
    classes = ["kt-tab"]

    # Active state
    classes << "active" if is_active

    # Variant-specific classes
    case variant
    when :pills
      classes << "rounded-full px-3 py-1.5 text-sm font-medium"
      classes << (is_active ? "bg-primary text-primary-foreground" : "text-muted-foreground hover:text-foreground hover:bg-accent")
    when :underline
      classes << "border-b-2 px-1 py-2 text-sm font-medium"
      classes << (is_active ? "border-primary text-primary" : "border-transparent text-muted-foreground hover:text-foreground hover:border-border")
    else
      classes << "px-3 py-2 text-sm font-medium rounded-md"
      classes << (is_active ? "bg-accent text-accent-foreground" : "text-muted-foreground hover:text-foreground hover:bg-accent")
    end

    # Size adjustments
    case size
    when :sm then classes << "text-xs"
    when :lg then classes << "text-base"
    end

    classes.join(" ")
  end

  def build_tab_panel_class(is_active)
    classes = ["kt-tab-panel"]
    classes << "block" if is_active
    classes << "hidden" unless is_active
    classes.join(" ")
  end
end