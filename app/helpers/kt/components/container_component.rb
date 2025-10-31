# app/helpers/kt/components/container_component.rb
module KT::Components::ContainerComponent
  include KT::BaseUiHelper

  # ✅ SRP: Basic container component
  def ui_container(size: :default, padding: :default, centered: false, **options, &block)
    classes = build_container_classes(size: size, padding: padding, centered: centered)
    content_tag(:div, class: classes, **options, &block)
  end

  # ✅ SRP: Fluid container (full width)
  def ui_container_fluid(padding: :default, **options, &block)
    classes = build_container_classes(size: :fluid, padding: padding)
    content_tag(:div, class: classes, **options, &block)
  end

  # ✅ SRP: Fixed width container
  def ui_container_fixed(max_width: :lg, padding: :default, centered: true, **options, &block)
    classes = build_container_classes(size: :fixed, max_width: max_width, padding: padding, centered: centered)
    content_tag(:div, class: classes, **options, &block)
  end

  # ✅ SRP: Box container with background and border
  def ui_box(variant: :default, padding: :md, shadow: false, rounded: true, **options, &block)
    classes = build_box_classes(variant: variant, padding: padding, shadow: shadow, rounded: rounded)
    content_tag(:div, class: classes, **options, &block)
  end

  private

  def build_container_classes(size:, padding:, centered: false, max_width: nil)
    classes = ["kt-container"]

    # Size classes
    case size
    when :sm
      classes << "max-w-4xl"
    when :md
      classes << "max-w-6xl"
    when :lg
      classes << "max-w-7xl"
    when :xl
      classes << "max-w-screen-xl"
    when :2xl
      classes << "max-w-screen-2xl"
    when :fluid
      classes << "w-full"
    when :fixed
      classes << "container mx-auto"
    end

    # Max width for fixed containers
    if size == :fixed && max_width
      width_class = case max_width
                    when :sm
                      "max-w-2xl"
                    when :md
                      "max-w-4xl"
                    when :lg
                      "max-w-6xl"
                    when :xl
                      "max-w-screen-lg"
                    when :2xl
                      "max-w-screen-xl"
                    else
                      "max-w-6xl"
                    end
      classes << width_class
    end

    # Padding classes
    padding_class = case padding
                    when :none
                      ""
                    when :sm
                      "px-4 py-2"
                    when :md
                      "px-6 py-4"
                    when :lg
                      "px-8 py-6"
                    when :xl
                      "px-12 py-8"
                    else
                      "px-4 py-4"
                    end
    classes << padding_class if padding_class.present?

    # Centering
    classes << "mx-auto" if centered

    classes.join(" ")
  end

  def build_box_classes(variant:, padding:, shadow:, rounded:)
    classes = ["kt-box"]

    # Variant classes
    case variant
    when :default then classes << "bg-background border border-border"
    when :elevated then classes << "bg-background border border-border shadow-lg"
    when :filled then classes << "bg-muted/50 border border-border"
    when :outlined then classes << "border-2 border-primary bg-transparent"
    end

    # Padding classes
    padding_class = case padding
                    when :none then ""
                    when :sm then "p-3"
                    when :md then "p-4"
                    when :lg then "p-6"
                    when :xl then "p-8"
                    else "p-4"
                    end
    classes << padding_class if padding_class.present?

    # Shadow
    classes << "shadow-md" if shadow

    # Rounded
    classes << "rounded-lg" if rounded

    classes.join(" ")
  end
end