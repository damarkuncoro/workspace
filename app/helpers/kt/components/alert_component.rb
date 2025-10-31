# app/helpers/kt/components/alert_component.rb
module KT::Components::AlertComponent
  include KT::BaseUiHelper

  # ✅ SRP: Basic alert component
  def ui_alert(message:, type: :info, dismissible: false, **options)
    classes = build_alert_class(type)
    content_tag(:div, class: classes, role: "alert", **options) do
      concat alert_icon(type)
      concat alert_content(message)
      concat alert_dismiss_button if dismissible
    end
  end

  # ✅ SRP: Alert with title
  def ui_alert_with_title(title:, message:, type: :info, dismissible: false, **options)
    classes = build_alert_class(type)
    content_tag(:div, class: classes, role: "alert", **options) do
      concat alert_icon(type)
      concat alert_title_content(title, message)
      concat alert_dismiss_button if dismissible
    end
  end

  # ✅ SRP: Inline alert (compact)
  def ui_alert_inline(message:, type: :info, **options)
    classes = build_alert_inline_class(type)
    content_tag(:div, class: classes, role: "alert", **options) do
      concat alert_icon(type, size: :xs)
      concat content_tag(:span, message, class: "text-sm")
    end
  end

  # ✅ SRP: Alert banner (full width)
  def ui_alert_banner(message:, type: :info, dismissible: true, **options)
    classes = build_alert_banner_class(type)
    content_tag(:div, class: classes, role: "alert", **options) do
      ui_container do
        content_tag(:div, class: "flex items-center justify-between") do
          concat content_tag(:div, class: "flex items-center gap-3") do
            concat alert_icon(type)
            concat content_tag(:p, message, class: "text-sm font-medium")
          end
          concat alert_dismiss_button if dismissible
        end
      end
    end
  end

  private

  def alert_icon(type, size: :sm)
    icon_name = case type
                when :success then "check-circle"
                when :error, :danger then "x-circle"
                when :warning then "alert-triangle"
                when :info then "info"
                else "info"
                end
    ui_icon(name: icon_name, size: size)
  end

  def alert_content(message)
    content_tag(:div, class: "kt-alert-content") do
      content_tag(:p, message, class: "text-sm")
    end
  end

  def alert_title_content(title, message)
    content_tag(:div, class: "kt-alert-content") do
      concat content_tag(:h4, title, class: "text-sm font-medium mb-1")
      concat content_tag(:p, message, class: "text-sm")
    end
  end

  def alert_dismiss_button
    content_tag(:button, class: "kt-alert-dismiss", type: "button", "aria-label": "Dismiss alert") do
      ui_icon(name: "x", size: :sm)
    end
  end

  def build_alert_class(type)
    classes = ["kt-alert"]

    type_class = case type
                 when :success then "kt-alert-success"
                 when :error, :danger then "kt-alert-error"
                 when :warning then "kt-alert-warning"
                 when :info then "kt-alert-info"
                 else "kt-alert-info"
                 end
    classes << type_class

    classes.join(" ")
  end

  def build_alert_inline_class(type)
    classes = ["kt-alert-inline", "inline-flex items-center gap-2 px-2 py-1 rounded-md text-xs"]

    type_class = case type
                 when :success then "bg-green-50 text-green-700 border border-green-200"
                 when :error, :danger then "bg-red-50 text-red-700 border border-red-200"
                 when :warning then "bg-yellow-50 text-yellow-700 border border-yellow-200"
                 when :info then "bg-blue-50 text-blue-700 border border-blue-200"
                 else "bg-blue-50 text-blue-700 border border-blue-200"
                 end
    classes << type_class

    classes.join(" ")
  end

  def build_alert_banner_class(type)
    classes = ["kt-alert-banner"]

    type_class = case type
                 when :success then "bg-green-50 border-b border-green-200"
                 when :error, :danger then "bg-red-50 border-b border-red-200"
                 when :warning then "bg-yellow-50 border-b border-yellow-200"
                 when :info then "bg-blue-50 border-b border-blue-200"
                 else "bg-blue-50 border-b border-blue-200"
                 end
    classes << type_class

    classes.join(" ")
  end
end