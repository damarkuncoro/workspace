# app/helpers/kt/components/slider_component.rb
module KT::Components::SliderComponent
  include KT::BaseUiHelper

  # ✅ SRP: Basic slider component
  def ui_slider(name:, value: 0, min: 0, max: 100, step: 1, label: nil, show_value: false, **options)
    slider_id = options[:id] || "slider-#{SecureRandom.hex(4)}"
    classes = build_slider_class(options.delete(:class))

    content_tag(:div, class: "kt-slider-wrapper") do
      concat slider_label(label, slider_id) if label
      concat slider_input(name, value, min, max, step, slider_id, classes, options)
      concat slider_track(slider_id)
      concat slider_value_display(value) if show_value
    end
  end

  # ✅ SRP: Range slider (dual handles)
  def ui_range_slider(name:, values: [0, 100], min: 0, max: 100, step: 1, label: nil, **options)
    slider_id = options[:id] || "range-slider-#{SecureRandom.hex(4)}"

    content_tag(:div, class: "kt-range-slider-wrapper") do
      concat slider_label(label, slider_id) if label
      concat range_slider_inputs(name, values, min, max, step, slider_id, options)
      concat range_slider_track(slider_id)
      concat range_slider_values(values)
    end
  end

  # ✅ SRP: Slider with marks
  def ui_slider_with_marks(name:, value: 0, marks: [], **options)
    slider_id = options[:id] || "slider-marks-#{SecureRandom.hex(4)}"

    content_tag(:div, class: "kt-slider-with-marks") do
      concat ui_slider(name, value: value, **options.except(:marks).merge(id: slider_id))
      concat slider_marks(marks, slider_id)
    end
  end

  private

  def slider_label(label, slider_id)
    label_for(label, slider_id, class: "kt-slider-label block text-sm font-medium mb-2")
  end

  def slider_input(name, value, min, max, step, slider_id, classes, options)
    range_field_tag(name, value, min: min, max: max, step: step, id: slider_id, class: classes, **options)
  end

  def slider_track(slider_id)
    content_tag(:div, class: "kt-slider-track", data: { "kt-slider-track": slider_id }) do
      content_tag(:div, "", class: "kt-slider-fill")
    end
  end

  def slider_value_display(value)
    content_tag(:div, value.to_s, class: "kt-slider-value text-sm text-muted-foreground mt-1")
  end

  def range_slider_inputs(name, values, min, max, step, slider_id, options)
    content_tag(:div, class: "kt-range-slider-inputs") do
      concat hidden_field_tag("#{name}[]", values[0], data: { "kt-range-slider": slider_id, "kt-range-slider-min": true })
      concat hidden_field_tag("#{name}[]", values[1], data: { "kt-range-slider": slider_id, "kt-range-slider-max": true })
      concat range_field_tag("#{name}_temp", values[0], min: min, max: max, step: step, class: "kt-range-slider-temp", **options)
    end
  end

  def range_slider_track(slider_id)
    content_tag(:div, class: "kt-range-slider-track", data: { "kt-range-slider-track": slider_id }) do
      content_tag(:div, "", class: "kt-range-slider-fill")
    end
  end

  def range_slider_values(values)
    content_tag(:div, class: "kt-range-slider-values flex justify-between text-sm text-muted-foreground mt-1") do
      concat content_tag(:span, values[0])
      concat content_tag(:span, values[1])
    end
  end

  def slider_marks(marks, slider_id)
    content_tag(:div, class: "kt-slider-marks relative", data: { "kt-slider-marks": slider_id }) do
      safe_join(marks.map do |mark|
        position = calculate_mark_position(mark[:value])
        content_tag(:div, class: "kt-slider-mark absolute", style: "left: #{position}%") do
          concat content_tag(:div, "", class: "kt-slider-mark-line")
          concat content_tag(:div, mark[:label], class: "kt-slider-mark-label") if mark[:label]
        end
      end)
    end
  end

  def calculate_mark_position(value, min: 0, max: 100)
    ((value - min).to_f / (max - min).to_f) * 100
  end

  def build_slider_class(additional_class)
    classes = ["kt-slider-input"]
    classes << additional_class if additional_class
    classes.join(" ")
  end
end