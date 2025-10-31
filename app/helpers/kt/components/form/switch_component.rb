# app/helpers/kt/components/switch_component.rb
module KT::Components::SwitchComponent
  include KT::UI::Base::BaseUIHelper

  # ✅ SRP: Basic switch/toggle component
  def ui_switch(name:, checked: false, label: nil, size: :md, color: :primary, **options)
    switch_id = options[:id] || "switch-#{SecureRandom.hex(4)}"
    classes = build_switch_class(size, color)

    content_tag(:label, class: "kt-switch-wrapper flex items-center gap-3 cursor-pointer", for: switch_id) do
      concat switch_input(name, checked, switch_id, options)
      concat switch_toggle(size, color)
      concat switch_label(label) if label
    end
  end

  # ✅ SRP: Switch with description
  def ui_switch_with_description(name:, checked: false, label:, description:, **options)
    switch_id = options[:id] || "switch-#{SecureRandom.hex(4)}"

    content_tag(:div, class: "kt-switch-with-description") do
      content_tag(:label, class: "flex items-start gap-3 cursor-pointer", for: switch_id) do
        concat switch_input(name, checked, switch_id, options)
        concat switch_toggle(:md, :primary)
        concat content_tag(:div, class: "flex-1") do
          concat content_tag(:div, label, class: "font-medium text-sm")
          concat content_tag(:div, description, class: "text-muted-foreground text-sm mt-1")
        end
      end
    end
  end

  # ✅ SRP: Switch group (multiple switches)
  def ui_switch_group(name:, options:, selected: [], orientation: :vertical, **group_options)
    content_tag(:div, class: "kt-switch-group #{orientation == :horizontal ? 'flex gap-6' : 'space-y-3'}") do
      safe_join(options.map do |option|
        checked = selected.include?(option[:value])
        ui_switch("#{name}[]", checked: checked, label: option[:label], value: option[:value], **group_options.except(:orientation))
      end)
    end
  end

  private

  def switch_input(name, checked, switch_id, options)
    check_box_tag(name, "1", checked, id: switch_id, class: "kt-switch-input hidden", **options)
  end

  def switch_toggle(size, color)
    size_class = case size
    when :sm then "w-8 h-5"
    when :md then "w-11 h-6"
    when :lg then "w-14 h-7"
    else "w-11 h-6"
    end

    color_class = case color
    when :primary then "kt-switch-primary"
    when :success then "kt-switch-success"
    when :warning then "kt-switch-warning"
    when :danger then "kt-switch-danger"
    else "kt-switch-primary"
    end

    content_tag(:div, class: "kt-switch-toggle #{size_class} #{color_class} relative inline-flex items-center rounded-full transition-colors") do
      content_tag(:div, "", class: "kt-switch-handle w-4 h-4 bg-white rounded-full shadow-md transform transition-transform translate-x-0.5")
    end
  end

  def switch_label(label)
    content_tag(:span, label, class: "kt-switch-label text-sm font-medium")
  end

  def build_switch_class(size, color)
    classes = [ "kt-switch" ]

    size_class = case size
    when :sm then "kt-switch-sm"
    when :md then "kt-switch-md"
    when :lg then "kt-switch-lg"
    else "kt-switch-md"
    end
    classes << size_class

    color_class = case color
    when :primary then "kt-switch-primary"
    when :success then "kt-switch-success"
    when :warning then "kt-switch-warning"
    when :danger then "kt-switch-danger"
    else "kt-switch-primary"
    end
    classes << color_class

    classes.join(" ")
  end
end
