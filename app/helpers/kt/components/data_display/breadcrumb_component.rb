# app/helpers/kt/components/breadcrumb_component.rb
module KT::Components::BreadcrumbComponent
  include KT::UI::Base::BaseUIHelper

  # ✅ SRP: Main breadcrumb component
  def ui_breadcrumb(items: [], separator: :chevron, variant: :default, **options)
    return "" if items.empty?

    classes = build_breadcrumb_classes(variant: variant)
    content_tag(:nav, class: classes, **options.merge("aria-label": "Breadcrumb")) do
      content_tag(:ol, class: "kt-breadcrumb-list flex items-center") do
        safe_join(items.each_with_index.map { |item, index| breadcrumb_item(item, index, items.size - 1, separator) })
      end
    end
  end

  # ✅ SRP: Individual breadcrumb item
  def breadcrumb_item(item, index, last_index, separator)
    content_tag(:li, class: "kt-breadcrumb-item flex items-center") do
      if index == last_index
        # Last item (current page)
        breadcrumb_current_item(item)
      else
        # Regular item with link
        concat breadcrumb_link_item(item)
        concat breadcrumb_separator(separator) unless index == last_index
      end
    end
  end

  # ✅ SRP: Link breadcrumb item
  def breadcrumb_link_item(item)
    link_to(item[:href] || "#", class: "kt-breadcrumb-link text-sm text-muted-foreground hover:text-foreground transition-colors", "aria-current": nil) do
      concat ui_icon(name: item[:icon], size: :xs) if item[:icon]
      concat item[:text]
    end
  end

  # ✅ SRP: Current page breadcrumb item
  def breadcrumb_current_item(item)
    content_tag(:span, class: "kt-breadcrumb-current text-sm font-medium text-foreground", "aria-current": "page") do
      concat ui_icon(name: item[:icon], size: :xs) if item[:icon]
      concat item[:text]
    end
  end

  # ✅ SRP: Breadcrumb separator
  def breadcrumb_separator(separator)
    content_tag(:span, class: "kt-breadcrumb-separator mx-2 text-muted-foreground", "aria-hidden": "true") do
      case separator
      when :chevron then ui_icon(name: "chevron-right", size: :xs)
      when :slash then "/"
      when :arrow then ui_icon(name: "arrow-right", size: :xs)
      when :bullet then "•"
      when :pipe then "|"
      else ui_icon(name: "chevron-right", size: :xs)
      end
    end
  end

  # ✅ SRP: Auto-generate breadcrumbs from controller/action
  def ui_breadcrumb_auto(separator: :chevron, variant: :default, **options)
    items = []

    # Add home
    items << { text: "Home", href: "/", icon: "home" }

    # Add controller-based breadcrumbs
    if controller_name != "home"
      items << { text: controller_name.humanize, href: "/#{controller_name}" }
    end

    # Add action-based breadcrumb (if not index)
    if action_name != "index" && action_name != "show"
      items << { text: action_name.humanize, href: nil }
    end

    ui_breadcrumb(items: items, separator: separator, variant: variant, **options)
  end

  private

  def build_breadcrumb_classes(variant:)
    classes = [ "kt-breadcrumb" ]

    case variant
    when :compact then classes << "text-sm"
    when :large then classes << "text-base"
    else classes << "text-sm"
    end

    classes.join(" ")
  end
end
