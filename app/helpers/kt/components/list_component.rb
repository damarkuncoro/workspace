# app/helpers/kt/components/list_component.rb
module KT::Components::ListComponent
  include KT::BaseUiHelper

  # ✅ SRP: Basic list component
  def ui_list(items: [], variant: :default, size: :md, **options)
    list_class = build_list_class(variant, size)

    content_tag(:ul, class: list_class, **options) do
      safe_join(items.map { |item| list_item(item, variant) })
    end
  end

  # ✅ SRP: Description list
  def ui_description_list(items: [], variant: :default, **options)
    list_class = build_description_list_class(variant)

    content_tag(:dl, class: list_class, **options) do
      safe_join(items.map { |item| description_list_item(item) })
    end
  end

  # ✅ SRP: List group (grouped items)
  def ui_list_group(items: [], variant: :default, **options)
    content_tag(:div, class: "kt-list-group", **options) do
      safe_join(items.map { |item| list_group_item(item, variant) })
    end
  end

  # ✅ SRP: Media list (image + content)
  def ui_media_list(items: [], **options)
    content_tag(:ul, class: "kt-media-list", **options) do
      safe_join(items.map { |item| media_list_item(item) })
    end
  end

  private

  def list_item(item, variant)
    content_tag(:li, class: "kt-list-item") do
      if item.is_a?(Hash)
        content_tag(:div, class: "flex items-center gap-3") do
          concat ui_icon(name: item[:icon], size: :sm) if item[:icon]
          concat item[:content] || item[:text]
          concat ui_badge(text: item[:badge], size: :xs) if item[:badge]
          concat item[:actions] if item[:actions]
        end
      else
        item
      end
    end
  end

  def description_list_item(item)
    content_tag(:div, class: "kt-description-item") do
      concat content_tag(:dt, item[:term], class: "kt-description-term")
      concat content_tag(:dd, item[:description], class: "kt-description-description")
    end
  end

  def list_group_item(item, variant)
    item_class = build_list_group_item_class(item[:active], variant)

    if item[:href]
      link_to(item[:href], class: item_class) do
        list_group_item_content(item)
      end
    else
      content_tag(:div, class: item_class) do
        list_group_item_content(item)
      end
    end
  end

  def list_group_item_content(item)
    content_tag(:div, class: "flex items-center justify-between") do
      concat content_tag(:div, class: "flex items-center gap-3") do
        concat ui_icon(name: item[:icon], size: :sm) if item[:icon]
        concat item[:text]
        concat ui_badge(text: item[:badge], size: :xs) if item[:badge]
      end
      concat item[:actions] if item[:actions]
    end
  end

  def media_list_item(item)
    content_tag(:li, class: "kt-media-item") do
      content_tag(:div, class: "flex gap-4") do
        concat media_list_media(item[:media])
        concat media_list_body(item)
      end
    end
  end

  def media_list_media(media)
    content_tag(:div, class: "kt-media") do
      if media[:image]
        image_tag(media[:image], class: "w-12 h-12 rounded", alt: "")
      elsif media[:icon]
        ui_icon(name: media[:icon], size: :lg, wrapper_class: "w-12 h-12 flex items-center justify-center bg-muted rounded")
      else
        content_tag(:div, class: "w-12 h-12 bg-muted rounded flex items-center justify-center") do
          ui_icon(name: "user", size: :lg)
        end
      end
    end
  end

  def media_list_body(item)
    content_tag(:div, class: "kt-media-body flex-1") do
      concat content_tag(:h4, item[:title], class: "font-medium") if item[:title]
      concat content_tag(:p, item[:text], class: "text-sm text-muted-foreground") if item[:text]
      concat item[:actions] if item[:actions]
    end
  end

  def build_list_class(variant, size)
    classes = ["kt-list"]

    case variant
    when :bordered then classes << "kt-list-bordered"
    when :separated then classes << "kt-list-separated"
    else classes << "kt-list-default"
    end

    case size
    when :sm then classes << "kt-list-sm"
    when :lg then classes << "kt-list-lg"
    else classes << "kt-list-md"
    end

    classes.join(" ")
  end

  def build_description_list_class(variant)
    classes = ["kt-description-list"]

    case variant
    when :horizontal then classes << "kt-description-list-horizontal"
    else classes << "kt-description-list-vertical"
    end

    classes.join(" ")
  end

  def build_list_group_item_class(active, variant)
    classes = ["kt-list-group-item"]

    classes << "active" if active

    case variant
    when :flush then classes << "kt-list-group-item-flush"
    else classes << "kt-list-group-item-default"
    end

    classes.join(" ")
  end
end