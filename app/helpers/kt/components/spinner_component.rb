# app/helpers/kt/components/spinner_component.rb
module KT::Components::SpinnerComponent
  include KT::BaseUiHelper

  # ✅ SRP: Basic spinner component
  def ui_spinner(size: :md, color: :primary, **options)
    classes = build_spinner_class(size, color)
    content_tag(:div, class: classes, "aria-hidden": "true", **options)
  end

  # ✅ SRP: Spinner with label
  def ui_spinner_with_label(label:, size: :md, color: :primary, **options)
    content_tag(:div, class: "kt-spinner-with-label flex items-center gap-3", **options) do
      concat ui_spinner(size: size, color: color)
      concat content_tag(:span, label, class: "text-sm text-muted-foreground")
    end
  end

  # ✅ SRP: Button with spinner (loading state)
  def ui_button_with_spinner(text:, loading: false, size: :md, spinner_size: :sm, **options)
    if loading
      options[:disabled] = true
      content_tag(:button, class: build_button_class(options), **options) do
        content_tag(:div, class: "flex items-center gap-2") do
          concat ui_spinner(size: spinner_size, color: :white)
          concat content_tag(:span, "Loading...", class: "text-sm")
        end
      end
    else
      ui_button(text: text, **options)
    end
  end

  # ✅ SRP: Page loading spinner
  def ui_page_loader(**options)
    content_tag(:div, class: "kt-page-loader fixed inset-0 z-50 flex items-center justify-center bg-background/80 backdrop-blur-sm", **options) do
      content_tag(:div, class: "text-center") do
        concat ui_spinner(size: :lg)
        concat content_tag(:p, "Loading...", class: "mt-4 text-sm text-muted-foreground")
      end
    end
  end

  # ✅ SRP: Inline loading state
  def ui_loading_state(content:, loading: false, spinner_size: :sm, **options)
    if loading
      content_tag(:div, class: "kt-loading-state flex items-center gap-3", **options) do
        concat ui_spinner(size: spinner_size)
        concat content_tag(:span, "Loading...", class: "text-sm text-muted-foreground")
      end
    else
      content
    end
  end

  # ✅ SRP: Skeleton loader
  def ui_skeleton(height: "h-4", width: "w-full", rounded: true, **options)
    classes = ["kt-skeleton", "bg-muted animate-pulse"]
    classes << height
    classes << width
    classes << "rounded" if rounded

    content_tag(:div, class: classes.join(" "), **options)
  end

  # ✅ SRP: Skeleton text
  def ui_skeleton_text(lines: 3, **options)
    content_tag(:div, class: "kt-skeleton-text space-y-2", **options) do
      lines.times do |i|
        width_class = i == lines - 1 ? "w-3/4" : "w-full" # Last line shorter
        concat ui_skeleton(height: "h-4", width: width_class)
      end
    end
  end

  # ✅ SRP: Skeleton card
  def ui_skeleton_card(**options)
    content_tag(:div, class: "kt-skeleton-card p-6 border border-border rounded-lg", **options) do
      content_tag(:div, class: "space-y-4") do
        concat ui_skeleton(height: "h-6", width: "w-1/2") # Title
        concat ui_skeleton_text(lines: 2) # Description
        concat content_tag(:div, class: "flex gap-2") do
          concat ui_skeleton(height: "h-8", width: "w-20") # Button 1
          concat ui_skeleton(height: "h-8", width: "w-16") # Button 2
        end
      end
    end
  end

  # ✅ SRP: Skeleton avatar
  def ui_skeleton_avatar(size: :md, **options)
    size_class = case size
                 when :xs then "w-6 h-6"
                 when :sm then "w-8 h-8"
                 when :lg then "w-12 h-12"
                 when :xl then "w-16 h-16"
                 else "w-10 h-10"
                 end

    ui_skeleton(height: size_class.split.first, width: size_class.split.last, rounded: true, **options)
  end

  private

  def build_spinner_class(size, color)
    classes = ["kt-spinner", "inline-block animate-spin rounded-full border-2 border-current border-t-transparent"]

    # Size
    size_class = case size
                 when :xs then "w-3 h-3"
                 when :sm then "w-4 h-4"
                 when :md then "w-6 h-6"
                 when :lg then "w-8 h-8"
                 when :xl then "w-12 h-12"
                 else "w-6 h-6"
                 end
    classes << size_class

    # Color
    color_class = case color
                  when :primary then "text-primary"
                  when :secondary then "text-secondary"
                  when :muted then "text-muted-foreground"
                  when :white then "text-white"
                  else "text-primary"
                  end
    classes << color_class

    classes.join(" ")
  end

  def build_button_class(options)
    variant = options.delete(:variant) || :primary
    size = options.delete(:size) || :md

    classes = ["kt-btn"]
    classes << "kt-btn-#{variant}"
    classes << "kt-btn-#{size}" unless size == :md
    classes << "opacity-50 cursor-not-allowed"

    classes.join(" ")
  end
end