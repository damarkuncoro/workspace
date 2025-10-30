
module KT::Container::ContainerHelper
  # ✅ SRP: Container dinamis untuk layout
  def container(columns: 3, gap: "gap-5 lg:gap-7.5", container_class: "kt-container-fixed", grid_class: nil, &block)
    grid_class ||= "grid grid-cols-1 xl:grid-cols-#{columns} #{gap} py-5"
    content_tag(:div, class: container_class) do
      content_tag(:div, class: grid_class) do
        capture(&block)
      end
    end
  end

  # ✅ SRP: Container sederhana tanpa grid
  def simple_container(container_class: "kt-container-fixed", &block)
    content_tag(:div, class: container_class) do
      capture(&block)
    end
  end

  # ✅ SRP: Container dengan custom wrapper
  def custom_container(wrapper_class: "kt-container-fixed", inner_class: nil, &block)
    content_tag(:div, class: wrapper_class) do
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