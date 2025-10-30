module KT::Container::ColumnHelper
  # ✅ SRP: Column dalam container
  def column(span: 1, gap: "gap-5 lg:gap-7.5", column_class: "col-span-#{span}", inner_class: "grid #{gap}", &block)
    content_tag(:div, class: column_class) do
      if inner_class
        content_tag(:div, class: inner_class) do
          capture(&block)
        end
      else
        capture(&block)
      end
    end
  end

  # ✅ SRP: Column sederhana tanpa inner wrapper
  def simple_column(span: 1, column_class: "col-span-#{span}", &block)
    content_tag(:div, class: column_class) do
      capture(&block)
    end
  end

  # ✅ SRP: Column dengan custom classes
  def custom_column(column_class: "col-span-1", inner_class: nil, &block)
    content_tag(:div, class: column_class) do
      if inner_class
        content_tag(:div, class: inner_class) do
          capture(&block)
        end
      else
        capture(&block)
      end
    end
  end
end