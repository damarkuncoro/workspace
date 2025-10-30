module KT::ContainerHelper
  include KT::Container::ContainerHelper
  include KT::Container::ColumnHelper

  # ✅ SRP: Layout builder untuk berbagai kebutuhan
  def layout_container(type: :grid, columns: 3, gap: "gap-5 lg:gap-7.5", container_class: "kt-container-fixed", &block)
    case type
    when :grid
      container(columns: columns, gap: gap, container_class: container_class, &block)
    when :simple
      simple_container(container_class: container_class, &block)
    when :custom
      custom_container(wrapper_class: container_class, &block)
    else
      container(columns: columns, gap: gap, container_class: container_class, &block)
    end
  end

  # ✅ SRP: Responsive column builder
  def responsive_column(span: 1, span_lg: nil, span_xl: nil, gap: "gap-5 lg:gap-7.5", &block)
    classes = ["col-span-#{span}"]
    classes << "lg:col-span-#{span_lg}" if span_lg
    classes << "xl:col-span-#{span_xl}" if span_xl
    column_class = classes.join(" ")

    column(span: span, gap: gap, column_class: column_class, &block)
  end
end