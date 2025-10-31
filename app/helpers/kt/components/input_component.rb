# app/helpers/kt/components/input_component.rb
module KT::Components::InputComponent
  include KT::BaseUiHelper

  # ✅ SRP: Basic input field component
  def ui_input_field(name:, type: :text, value: nil, placeholder: nil, label: nil, error: nil, help: nil, required: false, disabled: false, **options)
    wrapper_class = build_input_wrapper_class(error: error)
    input_class = build_input_class(disabled: disabled)

    content_tag(:div, class: wrapper_class) do
      concat ui_label(text: label, required: required, for: name) if label
      concat text_field_tag(name, value, type: type, placeholder: placeholder, class: input_class, disabled: disabled, required: required, **options)
      concat ui_help_text(text: help) if help
      concat ui_error_text(text: error) if error
    end
  end

  # ✅ SRP: Textarea component
  def ui_textarea_field(name:, value: nil, placeholder: nil, label: nil, error: nil, help: nil, required: false, disabled: false, rows: 3, **options)
    wrapper_class = build_input_wrapper_class(error: error)
    textarea_class = build_textarea_class(disabled: disabled)

    content_tag(:div, class: wrapper_class) do
      concat ui_label(text: label, required: required, for: name) if label
      concat text_area_tag(name, value, placeholder: placeholder, class: textarea_class, disabled: disabled, required: required, rows: rows, **options)
      concat ui_help_text(text: help) if help
      concat ui_error_text(text: error) if error
    end
  end

  # ✅ SRP: Email input
  def ui_email_field(name:, value: nil, placeholder: "Enter email address", **options)
    ui_input_field(name: name, type: :email, value: value, placeholder: placeholder, **options)
  end

  # ✅ SRP: Password input
  def ui_password_field(name:, value: nil, placeholder: "Enter password", **options)
    ui_input_field(name: name, type: :password, value: value, placeholder: placeholder, **options)
  end

  # ✅ SRP: Number input
  def ui_number_field(name:, value: nil, placeholder: nil, min: nil, max: nil, step: 1, **options)
    ui_input_field(name: name, type: :number, value: value, placeholder: placeholder, min: min, max: max, step: step, **options)
  end

  # ✅ SRP: Search input
  def ui_search_field(name:, value: nil, placeholder: "Search...", **options)
    wrapper_class = "relative"
    content_tag(:div, class: wrapper_class) do
      concat ui_icon(icon_class: "ki-filled ki-magnifier", icon_wrapper_class: "absolute left-3 top-1/2 transform -translate-y-1/2 text-muted-foreground")
      concat ui_input_field(name: name, value: value, placeholder: placeholder, class: "pl-10", **options.except(:label, :error, :help))
    end
  end

  private

  def build_input_wrapper_class(error: nil)
    classes = ["kt-form-group"]
    classes << "kt-form-group-error" if error
    classes.join(" ")
  end

  def build_input_class(disabled: false)
    classes = ["kt-input"]
    classes << "kt-input-disabled" if disabled
    classes.join(" ")
  end

  def build_textarea_class(disabled: false)
    classes = ["kt-textarea"]
    classes << "kt-textarea-disabled" if disabled
    classes.join(" ")
  end

  def ui_label(text:, required: false, for: nil)
    content_tag(:label, for: for, class: "kt-label") do
      concat text
      concat content_tag(:span, "*", class: "text-red-500 ml-1") if required
    end
  end

  def ui_help_text(text:)
    content_tag(:p, text, class: "kt-help-text text-sm text-muted-foreground mt-1")
  end

  def ui_error_text(text:)
    content_tag(:p, text, class: "kt-error-text text-sm text-red-500 mt-1")
  end
end