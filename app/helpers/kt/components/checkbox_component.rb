# app/helpers/kt/components/checkbox_component.rb
module KT::Components::CheckboxComponent
  include KT::BaseUiHelper

  # ✅ SRP: Single checkbox component
  def ui_checkbox(name:, value: "1", checked: false, label: nil, error: nil, help: nil, disabled: false, **options)
    wrapper_class = build_checkbox_wrapper_class(error: error)

    content_tag(:div, class: wrapper_class) do
      concat build_checkbox_input(name: name, value: value, checked: checked, disabled: disabled, **options)
      concat ui_label(text: label, for: name) if label
      concat ui_help_text(text: help) if help
      concat ui_error_text(text: error) if error
    end
  end

  # ✅ SRP: Checkbox group for multiple options
  def ui_checkbox_group(name:, options: [], selected: [], label: nil, error: nil, help: nil, disabled: false, orientation: :vertical)
    wrapper_class = build_checkbox_group_wrapper_class(error: error, orientation: orientation)

    content_tag(:div, class: wrapper_class) do
      concat ui_label(text: label) if label
      concat build_checkbox_group_options(name: name, options: options, selected: selected, disabled: disabled)
      concat ui_help_text(text: help) if help
      concat ui_error_text(text: error) if error
    end
  end

  # ✅ SRP: Switch component (toggle checkbox)
  def ui_switch(name:, value: "1", checked: false, label: nil, on_label: nil, off_label: nil, disabled: false, **options)
    wrapper_class = "flex items-center gap-3"

    content_tag(:div, class: wrapper_class) do
      concat build_switch_input(name: name, value: value, checked: checked, disabled: disabled, **options)
      concat build_switch_labels(on_label: on_label, off_label: off_label, label: label)
    end
  end

  private

  def build_checkbox_input(name:, value:, checked:, disabled:, **options)
    content_tag(:div, class: "flex items-center") do
      check_box_tag(name, value, checked, class: "kt-checkbox", disabled: disabled, **options)
    end
  end

  def build_checkbox_wrapper_class(error: nil)
    classes = ["kt-checkbox-wrapper"]
    classes << "kt-checkbox-wrapper-error" if error
    classes.join(" ")
  end

  def build_checkbox_group_wrapper_class(error: nil, orientation: :vertical)
    classes = ["kt-checkbox-group"]
    classes << "kt-checkbox-group-horizontal" if orientation == :horizontal
    classes << "kt-checkbox-group-error" if error
    classes.join(" ")
  end

  def build_checkbox_group_options(name:, options:, selected:, disabled:)
    content_tag(:div, class: "space-y-2") do
      safe_join(options.map do |option|
        value, text = option.is_a?(Array) ? option : [option, option]
        checked = selected.include?(value.to_s)
        ui_checkbox(name: name, value: value, checked: checked, label: text, disabled: disabled)
      end)
    end
  end

  def build_switch_input(name:, value:, checked:, disabled:, **options)
    check_box_tag(name, value, checked, class: "kt-switch", disabled: disabled, **options)
  end

  def build_switch_labels(on_label: nil, off_label: nil, label: nil)
    content_tag(:div, class: "flex flex-col") do
      concat content_tag(:span, label, class: "text-sm font-medium") if label
      if on_label || off_label
        concat content_tag(:div, class: "flex gap-2 text-xs text-muted-foreground") do
          concat content_tag(:span, off_label || "Off") if off_label || on_label
          concat content_tag(:span, "/", class: "mx-1") if off_label && on_label
          concat content_tag(:span, on_label || "On") if on_label || off_label
        end
      end
    end
  end

  def ui_label(text:, for: nil)
    content_tag(:label, text, for: for, class: "kt-label text-sm cursor-pointer")
  end

  def ui_help_text(text:)
    content_tag(:p, text, class: "kt-help-text text-sm text-muted-foreground mt-1")
  end

  def ui_error_text(text:)
    content_tag(:p, text, class: "kt-error-text text-sm text-red-500 mt-1")
  end
end