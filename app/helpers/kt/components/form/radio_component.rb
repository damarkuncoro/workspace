# app/helpers/kt/components/form/radio_component.rb
module KT::Components::Form::RadioComponent
  include KT::UI::Base::BaseUIHelper

  # ===============================
  # 🔹 RADIO COMPONENTS
  # ===============================

  # ✅ SRP: Single radio button component
  def ui_radio_button(name:, value:, checked: false, label: nil, error: nil, help: nil, disabled: false, **options)
    wrapper_class = build_radio_wrapper_class(error: error)

    content_tag(:div, class: wrapper_class) do
      concat build_radio_input(name: name, value: value, checked: checked, disabled: disabled, **options)
      concat ui_label(text: label, for: "#{name}_#{value}") if label
      concat ui_help_text(text: help) if help
      concat ui_error_text(text: error) if error
    end
  end

  # ✅ SRP: Radio button group for single selection
  def ui_radio_group(name:, options: [], selected: nil, label: nil, error: nil, help: nil, disabled: false, orientation: :vertical)
    wrapper_class = build_radio_group_wrapper_class(error: error, orientation: orientation)

    content_tag(:div, class: wrapper_class) do
      concat ui_label(text: label) if label
      concat build_radio_group_options(name: name, options: options, selected: selected, disabled: disabled)
      concat ui_help_text(text: help) if help
      concat ui_error_text(text: error) if error
    end
  end

  # ✅ SRP: Radio button with custom content
  def ui_radio_card(name:, value:, checked: false, content:, disabled: false, **options)
    wrapper_class = build_radio_card_wrapper_class(checked: checked, disabled: disabled)

    content_tag(:label, class: wrapper_class) do
      concat radio_button_tag(name, value, checked, disabled: disabled, **options)
      concat content_tag(:div, content, class: "kt-radio-card-content")
    end
  end

  private

  def build_radio_input(name:, value:, checked:, disabled:, **options)
    content_tag(:div, class: "flex items-center") do
      radio_button_tag(name, value, checked, class: "kt-radio", disabled: disabled, **options)
    end
  end

  def build_radio_wrapper_class(error: nil)
    classes = ["kt-radio-wrapper"]
    classes << "kt-radio-wrapper-error" if error
    classes.join(" ")
  end

  def build_radio_group_wrapper_class(error: nil, orientation: :vertical)
    classes = ["kt-radio-group"]
    classes << "kt-radio-group-horizontal" if orientation == :horizontal
    classes << "kt-radio-group-error" if error
    classes.join(" ")
  end

  def build_radio_card_wrapper_class(checked:, disabled:)
    classes = ["kt-radio-card"]
    classes << "kt-radio-card-checked" if checked
    classes << "kt-radio-card-disabled" if disabled
    classes.join(" ")
  end

  def build_radio_group_options(name:, options:, selected:, disabled:)
    content_tag(:div, class: "space-y-2") do
      safe_join(options.map do |option|
        value, text = option.is_a?(Array) ? option : [option, option]
        checked = selected.to_s == value.to_s
        ui_radio_button(name: name, value: value, checked: checked, label: text, disabled: disabled)
      end)
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