# app/helpers/kt/components/spacer_component.rb
module KT::Components::SpacerComponent
  include KT::BaseUiHelper

  # ✅ SRP: Basic spacer component
  def ui_spacer(size: :md, axis: :vertical, **options)
    classes = build_spacer_classes(size: size, axis: axis)
    content_tag(:div, class: classes, **options)
  end

  # ✅ SRP: Horizontal spacer
  def ui_spacer_horizontal(size: :md, **options)
    ui_spacer(size: size, axis: :horizontal, **options)
  end

  # ✅ SRP: Vertical spacer
  def ui_spacer_vertical(size: :md, **options)
    ui_spacer(size: size, axis: :vertical, **options)
  end

  # ✅ SRP: Flexible spacer (grows to fill space)
  def ui_spacer_flex(grow: 1, **options)
    classes = "kt-spacer-flex flex-grow-#{grow}"
    content_tag(:div, class: classes, **options)
  end

  # ✅ SRP: Spacer with minimum size
  def ui_spacer_min(size: :md, axis: :vertical, **options)
    classes = build_spacer_min_classes(size: size, axis: axis)
    content_tag(:div, class: classes, **options)
  end

  # ✅ SRP: Responsive spacer
  def ui_spacer_responsive(sizes: {}, axis: :vertical, **options)
    classes = build_responsive_spacer_classes(sizes: sizes, axis: axis)
    content_tag(:div, class: classes, **options)
  end

  # ✅ SRP: Spacer separator (visual and spatial)
  def ui_spacer_separator(size: :md, show_line: false, **options)
    classes = build_spacer_separator_classes(size: size, show_line: show_line)
    content_tag(:div, class: classes, **options)
  end

  private

  def build_spacer_classes(size:, axis:)
    classes = ["kt-spacer"]

    # Size
    size_class = case size
                 when :xs then axis == :vertical ? "h-1" : "w-1"
                 when :sm then axis == :vertical ? "h-2" : "w-2"
                 when :md then axis == :vertical ? "h-4" : "w-4"
                 when :lg then axis == :vertical ? "h-6" : "w-6"
                 when :xl then axis == :vertical ? "h-8" : "w-8"
                 when :2xl then axis == :vertical ? "h-12" : "w-12"
                 when :3xl then axis == :vertical ? "h-16" : "w-16"
                 when :4xl then axis == :vertical ? "h-20" : "w-20"
                 else axis == :vertical ? "h-4" : "w-4"
                 end
    classes << size_class

    classes.join(" ")
  end

  def build_spacer_min_classes(size:, axis:)
    classes = ["kt-spacer-min"]

    # Minimum size
    min_class = case size
                when :xs then axis == :vertical ? "min-h-1" : "min-w-1"
                when :sm then axis == :vertical ? "min-h-2" : "min-w-2"
                when :md then axis == :vertical ? "min-h-4" : "min-w-4"
                when :lg then axis == :vertical ? "min-h-6" : "min-w-6"
                when :xl then axis == :vertical ? "min-h-8" : "min-w-8"
                else axis == :vertical ? "min-h-4" : "min-w-4"
                end
    classes << min_class

    classes.join(" ")
  end

  def build_responsive_spacer_classes(sizes:, axis:)
    classes = ["kt-spacer-responsive"]

    # Default size
    default_size = sizes[:default] || :md
    classes << build_spacer_classes(size: default_size, axis: axis).split.last

    # Responsive sizes
    sizes.except(:default).each do |breakpoint, size|
      prefix = case breakpoint
               when :sm then "sm:"
               when :md then "md:"
               when :lg then "lg:"
               when :xl then "xl:"
               when :2xl then "2xl:"
               else ""
               end

      if prefix.present?
        responsive_class = case size
                           when :xs then axis == :vertical ? "#{prefix}h-1" : "#{prefix}w-1"
                           when :sm then axis == :vertical ? "#{prefix}h-2" : "#{prefix}w-2"
                           when :md then axis == :vertical ? "#{prefix}h-4" : "#{prefix}w-4"
                           when :lg then axis == :vertical ? "#{prefix}h-6" : "#{prefix}w-6"
                           when :xl then axis == :vertical ? "#{prefix}h-8" : "#{prefix}w-8"
                           else axis == :vertical ? "#{prefix}h-4" : "#{prefix}w-4"
                           end
        classes << responsive_class
      end
    end

    classes.join(" ")
  end

  def build_spacer_separator_classes(size:, show_line:)
    classes = ["kt-spacer-separator"]

    # Size
    size_class = case size
                 when :xs then "h-1"
                 when :sm then "h-2"
                 when :md then "h-4"
                 when :lg then "h-6"
                 when :xl then "h-8"
                 else "h-4"
                 end
    classes << size_class

    # Line
    if show_line
      classes << "border-t border-border"
    end

    classes.join(" ")
  end
end