# app/helpers/kt/components/tag_component.rb
module KT::Components::TagComponent
  include KT::UI::Base::BaseUIHelper

  # ✅ SRP: Basic tag component
  def ui_tag(text:, variant: :default, size: :md, closable: false, **options)
    classes = build_tag_class(variant, size)
    content_tag(:span, class: classes, **options) do
      concat content_tag(:span, text, class: "kt-tag-text")
      concat tag_close_button if closable
    end
  end

  # ✅ SRP: Tag group
  def ui_tag_group(tags: [], variant: :default, size: :md, max: nil, **options)
    visible_tags = max ? tags.first(max) : tags
    remaining_count = max && tags.size > max ? tags.size - max : 0

    content_tag(:div, class: "kt-tag-group flex flex-wrap gap-2", **options) do
      safe_join(visible_tags.map { |tag| ui_tag(**tag.merge(variant: variant, size: size)) })
      concat tag_overflow(remaining_count, variant, size) if remaining_count > 0
    end
  end

  # ✅ SRP: Filter tag
  def ui_filter_tag(text:, active: false, removable: true, **options)
    variant = active ? :primary : :outline
    ui_tag(text: text, variant: variant, closable: removable, **options)
  end

  # ✅ SRP: Category tag
  def ui_category_tag(text:, category:, **options)
    color_class = category_color_class(category)
    ui_tag(text: text, class: color_class, **options)
  end

  private

  def tag_close_button
    content_tag(:button, class: "kt-tag-close", type: "button", "aria-label": "Remove tag") do
      ui_icon(name: "x", size: :xs)
    end
  end

  def tag_overflow(count, variant, size)
    ui_tag(text: "+#{count} more", variant: :secondary, size: size)
  end

  def build_tag_class(variant, size)
    classes = [ "kt-tag" ]

    # Variant
    case variant
    when :primary then classes << "kt-tag-primary"
    when :secondary then classes << "kt-tag-secondary"
    when :success then classes << "kt-tag-success"
    when :danger then classes << "kt-tag-danger"
    when :warning then classes << "kt-tag-warning"
    when :info then classes << "kt-tag-info"
    when :light then classes << "kt-tag-light"
    when :dark then classes << "kt-tag-dark"
    when :outline then classes << "kt-tag-outline"
    else classes << "kt-tag-default"
    end

    # Size
    case size
    when :xs then classes << "kt-tag-xs"
    when :sm then classes << "kt-tag-sm"
    when :lg then classes << "kt-tag-lg"
    else classes << "kt-tag-md"
    end

    classes.join(" ")
  end

  def category_color_class(category)
    # Simple hash-based color assignment for categories
    colors = %w[
      bg-blue-100 text-blue-800
      bg-green-100 text-green-800
      bg-yellow-100 text-yellow-800
      bg-red-100 text-red-800
      bg-purple-100 text-purple-800
      bg-pink-100 text-pink-800
      bg-indigo-100 text-indigo-800
      bg-gray-100 text-gray-800
    ]

    index = category.to_s.sum % colors.length
    colors[index]
  end
end
