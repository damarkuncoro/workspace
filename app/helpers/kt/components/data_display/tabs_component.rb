# app/helpers/kt/components/tabs_component.rb
module KT::Components::TabsComponent
  include KT::UI::Base::BaseUIHelper

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
    variant_class = case variant
    when :pills then "kt-tabs-pills"
    when :underline then "kt-tabs-underline"
    else "kt-tabs-default"
    end

    size_class = case size
    when :sm then "kt-tabs-sm"
    when :lg then "kt-tabs-lg"
    else "kt-tabs-md"
    end

    build_classes("kt-tabs", variant_class, size_class, orientation == :vertical && "kt-tabs-vertical")
  end

  def build_tab_item_class(is_active, variant, size)
    active_class = is_active ? "active" : nil

    base_classes, state_classes = case variant
    when :pills
      ["rounded-full px-3 py-1.5 text-sm font-medium", is_active ? "bg-primary text-primary-foreground" : "text-muted-foreground hover:text-foreground hover:bg-accent"]
    when :underline
      ["border-b-2 px-1 py-2 text-sm font-medium", is_active ? "border-primary text-primary" : "border-transparent text-muted-foreground hover:text-foreground hover:border-border"]
    else
      ["px-3 py-2 text-sm font-medium rounded-md", is_active ? "bg-accent text-accent-foreground" : "text-muted-foreground hover:text-foreground hover:bg-accent"]
    end

    size_class = case size
    when :sm then "text-xs"
    when :lg then "text-base"
    end

    build_classes("kt-tab", active_class, base_classes, state_classes, size_class)
  end

  def build_tab_panel_class(is_active)
    build_classes("kt-tab-panel", is_active ? "block" : "hidden")
  end
end
