# app/helpers/kt/components/divider_component.rb
module KT::Components::DividerComponent
  include KT::BaseUiHelper

  # ✅ SRP: Basic horizontal divider
  def ui_divider(variant: :solid, thickness: :default, color: :border, spacing: :md, **options)
    classes = build_divider_classes(variant: variant, thickness: thickness, color: color, spacing: spacing, orientation: :horizontal)
    content_tag(:hr, class: classes, **options)
  end

  # ✅ SRP: Vertical divider
  def ui_divider_vertical(height: :full, variant: :solid, thickness: :default, color: :border, **options)
    classes = build_divider_classes(variant: variant, thickness: thickness, color: color, orientation: :vertical, height: height)
    content_tag(:div, class: classes, **options)
  end

  # ✅ SRP: Divider with text
  def ui_divider_with_text(text:, position: :center, variant: :solid, thickness: :default, color: :border, **options)
    wrapper_class = "kt-divider-with-text flex items-center"
    text_class = build_divider_text_class(position: position)

    content_tag(:div, class: wrapper_class, **options) do
      concat ui_divider(variant: variant, thickness: thickness, color: color, spacing: :sm, class: "flex-1")
      concat content_tag(:span, text, class: text_class)
      concat ui_divider(variant: variant, thickness: thickness, color: color, spacing: :sm, class: "flex-1")
    end
  end

  # ✅ SRP: Section divider with spacing
  def ui_section_divider(spacing: :lg, variant: :solid, thickness: :default, color: :muted, **options)
    classes = build_section_divider_classes(spacing: spacing)
    content_tag(:div, class: classes, **options) do
      ui_divider(variant: variant, thickness: thickness, color: color, spacing: :none)
    end
  end

  # ✅ SRP: Ornamental divider
  def ui_divider_ornamental(icon: nil, variant: :dotted, **options)
    wrapper_class = "kt-divider-ornamental flex items-center justify-center"

    content_tag(:div, class: wrapper_class, **options) do
      concat ui_divider(variant: variant, spacing: :lg, class: "flex-1")
      concat ui_icon(name: icon || "star", size: :sm, color: :muted, wrapper_class: "mx-4") if icon || block_given?
      concat ui_divider(variant: variant, spacing: :lg, class: "flex-1")
    end
  end

  private

  def build_divider_classes(variant:, thickness:, color:, spacing:, orientation: :horizontal, height: nil)
    classes = ["kt-divider"]

    # Orientation
    classes << (orientation == :vertical ? "kt-divider-vertical" : "kt-divider-horizontal")

    # Variant
    variant_class = case variant
                    when :solid then "border-solid"
                    when :dashed then "border-dashed"
                    when :dotted then "border-dotted"
                    when :double then "border-double"
                    else "border-solid"
                    end
    classes << variant_class

    # Thickness
    thickness_class = case thickness
                      when :thin then "border-t"
                      when :default then "border-t-2"
                      when :thick then "border-t-4"
                      else "border-t-2"
                      end
    classes << thickness_class

    # Color
    color_class = case color
                  when :border then "border-border"
                  when :muted then "border-muted-foreground/20"
                  when :primary then "border-primary"
                  when :secondary then "border-secondary"
                  else "border-border"
                  end
    classes << color_class

    # Spacing
    if orientation == :horizontal
      spacing_class = case spacing
                      when :none then ""
                      when :xs then "my-1"
                      when :sm then "my-2"
                      when :md then "my-4"
                      when :lg then "my-6"
                      when :xl then "my-8"
                      else "my-4"
                      end
      classes << spacing_class if spacing_class.present?
    else
      # Vertical divider
      height_class = case height
                     when :full then "h-full"
                     when :screen then "h-screen"
                     else "h-full"
                     end
      classes << height_class
      classes << "w-px mx-4" # Vertical line styling
    end

    classes.join(" ")
  end

  def build_divider_text_class(position:)
    base_class = "kt-divider-text px-3 text-sm font-medium"

    position_class = case position
                     when :left then "text-left"
                     when :center then "text-center"
                     when :right then "text-right"
                     else "text-center"
                     end

    "#{base_class} #{position_class} text-muted-foreground"
  end

  def build_section_divider_classes(spacing:)
    spacing_class = case spacing
                    when :xs then "py-2"
                    when :sm then "py-4"
                    when :md then "py-6"
                    when :lg then "py-8"
                    when :xl then "py-12"
                    when :2xl then "py-16"
                    else "py-8"
                    end

    "kt-section-divider #{spacing_class}"
  end
end