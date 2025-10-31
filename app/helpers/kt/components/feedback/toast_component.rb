# app/helpers/kt/components/toast_component.rb
module KT::Components::ToastComponent
  include KT::UI::Base::BaseUIHelper

  # ✅ SRP: Toast notification component
  def ui_toast(message:, type: :info, duration: 5000, **options)
    toast_id = "toast-#{SecureRandom.hex(4)}"
    classes = build_toast_class(type)
    data_attrs = {
      "kt-toast": true,
      "kt-toast-duration": duration,
      "kt-toast-id": toast_id
    }

    content_tag(:div, class: classes, data: data_attrs, **options) do
      concat toast_icon(type)
      concat toast_content(message)
      concat toast_close_button
    end
  end

  # ✅ SRP: Toast with title
  def ui_toast_with_title(title:, message:, type: :info, duration: 5000, **options)
    toast_id = "toast-#{SecureRandom.hex(4)}"
    classes = build_toast_class(type)
    data_attrs = {
      "kt-toast": true,
      "kt-toast-duration": duration,
      "kt-toast-id": toast_id
    }

    content_tag(:div, class: classes, data: data_attrs, **options) do
      concat toast_icon(type)
      concat toast_title_content(title, message)
      concat toast_close_button
    end
  end

  # ✅ SRP: Toast container (for positioning multiple toasts)
  def ui_toast_container(position: :bottom_right, **options)
    classes = build_toast_container_class(position)
    content_tag(:div, class: classes, "aria-live": "polite", "aria-label": "Toast notifications", **options)
  end

  # ✅ SRP: Success toast shortcut
  def ui_toast_success(message, **options)
    ui_toast(message: message, type: :success, **options)
  end

  # ✅ SRP: Error toast shortcut
  def ui_toast_error(message, **options)
    ui_toast(message: message, type: :error, **options)
  end

  # ✅ SRP: Warning toast shortcut
  def ui_toast_warning(message, **options)
    ui_toast(message: message, type: :warning, **options)
  end

  # ✅ SRP: Info toast shortcut
  def ui_toast_info(message, **options)
    ui_toast(message: message, type: :info, **options)
  end

  private

  def toast_icon(type)
    content_tag(:div, class: "kt-toast-icon") do
      icon_name = case type
      when :success then "check-circle"
      when :error then "x-circle"
      when :warning then "alert-triangle"
      when :info then "info"
      else "info"
      end
      ui_icon(name: icon_name, size: :sm)
    end
  end

  def toast_content(message)
    content_tag(:div, class: "kt-toast-content") do
      content_tag(:p, message, class: "text-sm")
    end
  end

  def toast_title_content(title, message)
    content_tag(:div, class: "kt-toast-content") do
      concat content_tag(:h4, title, class: "text-sm font-medium mb-1")
      concat content_tag(:p, message, class: "text-sm")
    end
  end

  def toast_close_button
    content_tag(:button, class: "kt-toast-close", type: "button", "aria-label": "Close toast") do
      ui_icon(name: "x", size: :sm)
    end
  end

  def build_toast_class(type)
    classes = [ "kt-toast" ]

    type_class = case type
    when :success then "kt-toast-success"
    when :error then "kt-toast-error"
    when :warning then "kt-toast-warning"
    when :info then "kt-toast-info"
    else "kt-toast-info"
    end
    classes << type_class

    classes.join(" ")
  end

  def build_toast_container_class(position)
    classes = [ "kt-toast-container", "fixed z-50 pointer-events-none" ]

    position_class = case position
    when :top_left then "top-4 left-4"
    when :top_right then "top-4 right-4"
    when :bottom_left then "bottom-4 left-4"
    when :bottom_right then "bottom-4 right-4"
    when :top_center then "top-4 left-1/2 transform -translate-x-1/2"
    when :bottom_center then "bottom-4 left-1/2 transform -translate-x-1/2"
    else "bottom-4 right-4"
    end
    classes << position_class

    classes.join(" ")
  end
end
