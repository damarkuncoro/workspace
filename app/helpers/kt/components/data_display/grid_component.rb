# app/helpers/kt/components/grid_component.rb
module KT::Components::GridComponent
  include KT::UI::Base::BaseUIHelper

  # ✅ SRP: CSS Grid layout component
  def ui_grid(columns: 1, gap: :md, responsive: true, **options, &block)
    classes = build_grid_classes(columns: columns, gap: gap, responsive: responsive, type: :grid)
    content_tag(:div, class: classes, **options, &block)
  end

  # ✅ SRP: Grid with auto-fit columns
  def ui_grid_auto(min_width: "200px", gap: :md, **options, &block)
    classes = build_grid_auto_classes(min_width: min_width, gap: gap)
    content_tag(:div, class: classes, **options, &block)
  end

  # ✅ SRP: Grid item component
  def ui_grid_item(span: 1, start: nil, **options, &block)
    classes = build_grid_item_classes(span: span, start: start)
    content_tag(:div, class: classes, **options, &block)
  end

  # ✅ SRP: Responsive grid with breakpoints
  def ui_grid_responsive(breakpoints: {}, gap: :md, **options, &block)
    classes = build_responsive_grid_classes(breakpoints: breakpoints, gap: gap)
    content_tag(:div, class: classes, **options, &block)
  end

  private

  def build_grid_classes(columns:, gap:, responsive:, type:)
    classes = ["kt-grid"]

    # Grid type
    classes << "grid" if type == :grid

    # Columns
    if responsive
      cols_class = case columns
                   when 1 then "grid-cols-1"
                   when 2 then "grid-cols-1 md:grid-cols-2"
                   when 3 then "grid-cols-1 md:grid-cols-2 lg:grid-cols-3"
                   when 4 then "grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4"
                   when 5 then "grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-5"
                   when 6 then "grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6"
                   else "grid-cols-#{columns}"
                   end
    else
      cols_class = "grid-cols-#{columns}"
    end
    classes << cols_class

    # Gap
    gap_class = case gap
                when :none then "gap-0"
                when :xs then "gap-1"
                when :sm then "gap-2"
                when :md then "gap-4"
                when :lg then "gap-6"
                when :xl then "gap-8"
                when :2xl then "gap-12"
                else "gap-4"
                end
    classes << gap_class

    classes.join(" ")
  end

  def build_grid_auto_classes(min_width:, gap:)
    classes = ["kt-grid-auto", "grid"]

    # Auto-fit with min-width
    classes << "grid-cols-[repeat(auto-fit,minmax(#{min_width},1fr))]"

    # Gap
    gap_class = case gap
                when :none then "gap-0"
                when :xs then "gap-1"
                when :sm then "gap-2"
                when :md then "gap-4"
                when :lg then "gap-6"
                when :xl then "gap-8"
                else "gap-4"
                end
    classes << gap_class

    classes.join(" ")
  end

  def build_grid_item_classes(span:, start:)
    classes = ["kt-grid-item"]

    # Span
    classes << "col-span-#{span}" if span && span > 1

    # Start position
    classes << "col-start-#{start}" if start

    classes.join(" ")
  end

  def build_responsive_grid_classes(breakpoints:, gap:)
    classes = ["kt-grid-responsive", "grid"]

    # Default columns
    default_cols = breakpoints[:default] || 1
    classes << "grid-cols-#{default_cols}"

    # Responsive breakpoints
    breakpoints.except(:default).each do |breakpoint, cols|
      prefix = case breakpoint
               when :sm then "sm:"
               when :md then "md:"
               when :lg then "lg:"
               when :xl then "xl:"
               when :2xl then "2xl:"
               else ""
               end
      classes << "#{prefix}grid-cols-#{cols}" if prefix.present?
    end

    # Gap
    gap_class = case gap
                when :none then "gap-0"
                when :xs then "gap-1"
                when :sm then "gap-2"
                when :md then "gap-4"
                when :lg then "gap-6"
                when :xl then "gap-8"
                else "gap-4"
                end
    classes << gap_class

    classes.join(" ")
  end
end