# app/helpers/kt/components/select_component.rb
module KT::Components::SelectComponent
  include KT::BaseUiHelper

  # ✅ SRP: Basic select dropdown component
  def ui_select_field(name:, options: [], selected: nil, placeholder: "Select an option", label: nil, error: nil, help: nil, required: false, disabled: false, multiple: false, **options)
    wrapper_class = build_select_wrapper_class(error: error)
    select_class = build_select_class(disabled: disabled)

    content_tag(:div, class: wrapper_class) do
      concat ui_label(text: label, required: required, for: name) if label
      concat build_select_element(name: name, options: options, selected: selected, placeholder: placeholder, class: select_class, disabled: disabled, required: required, multiple: multiple, **options)
      concat ui_help_text(text: help) if help
      concat ui_error_text(text: error) if error
    end
  end

  # ✅ SRP: Select with search functionality
  def ui_select_search(name:, options: [], selected: nil, placeholder: "Search and select...", label: nil, error: nil, help: nil, **options)
    wrapper_class = "relative"
    content_tag(:div, class: wrapper_class) do
      concat ui_icon(icon_class: "ki-filled ki-magnifier", icon_wrapper_class: "absolute left-3 top-1/2 transform -translate-y-1/2 text-muted-foreground z-10")
      concat ui_select_field(name: name, options: options, selected: selected, placeholder: placeholder, label: label, error: error, help: help, class: "pl-10", **options)
    end
  end

  # ✅ SRP: Multi-select component
  def ui_multi_select(name:, options: [], selected: [], placeholder: "Select options...", label: nil, error: nil, help: nil, **options)
    ui_select_field(name: name, options: options, selected: selected, placeholder: placeholder, label: label, error: error, help: help, multiple: true, **options)
  end

  # ✅ SRP: Select with custom option rendering
  def ui_select_custom(name:, options: [], selected: nil, placeholder: "Select an option", label: nil, **options)
    wrapper_class = build_select_wrapper_class

    content_tag(:div, class: wrapper_class) do
      concat ui_label(text: label, for: name) if label
      concat content_tag(:div, class: "kt-select-custom") do
        concat build_custom_select_trigger(selected: selected, placeholder: placeholder)
        concat build_custom_select_dropdown(options: options, selected: selected, name: name)
      end
    end
  end

  private

  def build_select_element(name:, options:, selected:, placeholder:, class:, disabled:, required:, multiple:, **options)
    select_tag(name, class: class, disabled: disabled, required: required, multiple: multiple, **options) do
      concat content_tag(:option, placeholder, value: "", disabled: true, selected: selected.nil?) unless multiple
      safe_join(build_select_options(options, selected, multiple))
    end
  end

  def build_select_options(options, selected, multiple)
    options.map do |option|
      value, text = option.is_a?(Array) ? option : [option, option]
      is_selected = multiple ? selected&.include?(value.to_s) : selected.to_s == value.to_s
      content_tag(:option, text, value: value, selected: is_selected)
    end
  end

  def build_select_wrapper_class(error: nil)
    classes = ["kt-select-wrapper"]
    classes << "kt-select-wrapper-error" if error
    classes.join(" ")
  end

  def build_select_class(disabled: false)
    classes = ["kt-select"]
    classes << "kt-select-disabled" if disabled
    classes.join(" ")
  end

  def build_custom_select_trigger(selected:, placeholder:)
    display_text = selected ? find_option_text(selected) : placeholder
    content_tag(:div, class: "kt-select-trigger", data: { "kt-select-trigger": true }) do
      concat content_tag(:span, display_text, class: "kt-select-value")
      concat ui_icon(icon_class: "ki-filled ki-down", icon_wrapper_class: "kt-select-arrow")
    end
  end

  def build_custom_select_dropdown(options:, selected:, name:)
    content_tag(:div, class: "kt-select-dropdown", data: { "kt-select-dropdown": true }) do
      safe_join(options.map do |option|
        value, text = option.is_a?(Array) ? option : [option, option]
        is_selected = selected.to_s == value.to_s
        content_tag(:div, class: "kt-select-option #{is_selected ? 'selected' : ''}", data: { value: value, name: name }) do
          concat text
          concat ui_icon(icon_class: "ki-filled ki-check", icon_wrapper_class: "kt-select-check") if is_selected
        end
      end)
    end
  end

  def find_option_text(value)
    # This would need to be implemented based on your options structure
    value.to_s.humanize
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