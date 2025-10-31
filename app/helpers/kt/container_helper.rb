module KT::ContainerHelper
  include KT::Container::ContainerHelper
  include KT::Container::ColumnHelper

  # ✅ SRP: Unified layout builder - consolidated logic
  def layout_container(type: :grid, columns: 3, gap: "gap-5 lg:gap-7.5", container_class: "kt-container-fixed", **options, &block)
    case type
    when :grid
      container(columns: columns, gap: gap, container_class: container_class, **options, &block)
    when :simple
      simple_container(container_class: container_class, **options, &block)
    when :custom
      custom_container(wrapper_class: container_class, **options, &block)
    else
      container(columns: columns, gap: gap, container_class: container_class, **options, &block)
    end
  end

  # ✅ SRP: Responsive column builder - enhanced with more breakpoints
  def responsive_column(span: 1, span_sm: nil, span_md: nil, span_lg: nil, span_xl: nil, gap: "gap-5 lg:gap-7.5", &block)
    classes = ["col-span-#{span}"]
    classes << "sm:col-span-#{span_sm}" if span_sm
    classes << "md:col-span-#{span_md}" if span_md
    classes << "lg:col-span-#{span_lg}" if span_lg
    classes << "xl:col-span-#{span_xl}" if span_xl
    column_class = classes.join(" ")

    column(span: span, gap: gap, column_class: column_class, &block)
  end

  # ✅ SRP: Fluid container variant
  def fluid_container(columns: 3, gap: "gap-5 lg:gap-7.5", &block)
    layout_container(type: :grid, columns: columns, gap: gap, container_class: "kt-container-fluid", &block)
  end

  # ✅ SRP: Centered container variant
  def centered_container(max_width: "max-w-4xl", &block)
    layout_container(type: :simple, container_class: "kt-container-fixed mx-auto #{max_width}", &block)
  end
end