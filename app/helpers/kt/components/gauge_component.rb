# app/helpers/kt/components/gauge_component.rb
module KT::Components::GaugeComponent
  include KT::BaseUiHelper

  # ✅ SRP: Basic gauge component
  def ui_gauge(value:, max: 100, label: nil, size: :md, color: :primary, **options)
    gauge_id = options[:id] || "gauge-#{SecureRandom.hex(4)}"
    percentage = calculate_percentage(value, max)
    classes = build_gauge_class(size, options.delete(:class))

    content_tag(:div, class: classes, **options) do
      concat gauge_svg(gauge_id, percentage, color)
      concat gauge_content(value, max, label, percentage)
    end
  end

  # ✅ SRP: Circular gauge
  def ui_gauge_circle(value:, max: 100, label: nil, **options)
    ui_gauge(value: value, max: max, label: label, **options)
  end

  # ✅ SRP: Semi-circular gauge
  def ui_gauge_semi(value:, max: 100, label: nil, **options)
    gauge_id = options[:id] || "gauge-semi-#{SecureRandom.hex(4)}"
    percentage = calculate_percentage(value, max)
    classes = build_gauge_semi_class(options.delete(:class))

    content_tag(:div, class: classes, **options) do
      concat gauge_semi_svg(gauge_id, percentage)
      concat gauge_content(value, max, label, percentage)
    end
  end

  # ✅ SRP: Progress meter (horizontal)
  def ui_meter(value:, max: 100, label: nil, color: :primary, **options)
    percentage = calculate_percentage(value, max)
    classes = build_meter_class(options.delete(:class))

    content_tag(:div, class: classes, **options) do
      concat meter_label(label) if label
      concat meter_bar(percentage, color)
      concat meter_value(value, max, percentage)
    end
  end

  # ✅ SRP: Multi-segment gauge
  def ui_gauge_multi(segments: [], label: nil, **options)
    gauge_id = options[:id] || "gauge-multi-#{SecureRandom.hex(4)}"
    classes = build_gauge_multi_class(options.delete(:class))

    content_tag(:div, class: classes, **options) do
      concat gauge_multi_svg(gauge_id, segments)
      concat gauge_multi_content(segments, label)
    end
  end

  # ✅ SRP: Status gauge with thresholds
  def ui_gauge_status(value:, max: 100, thresholds: {}, label: nil, **options)
    status = determine_status(value, max, thresholds)
    ui_gauge(value: value, max: max, label: label, color: status, **options)
  end

  private

  def calculate_percentage(value, max)
    [(value.to_f / max.to_f * 100).round, 100].min
  end

  def gauge_svg(gauge_id, percentage, color)
    radius = 40
    circumference = 2 * Math::PI * radius
    stroke_dasharray = circumference
    stroke_dashoffset = circumference - (percentage / 100.0) * circumference

    content_tag(:svg, class: "kt-gauge-svg", width: 100, height: 100, viewBox: "0 0 100 100") do
      concat gauge_background_circle(radius)
      concat gauge_progress_circle(radius, stroke_dasharray, stroke_dashoffset, color)
    end
  end

  def gauge_background_circle(radius)
    content_tag(:circle, "", cx: 50, cy: 50, r: radius, class: "kt-gauge-bg")
  end

  def gauge_progress_circle(radius, stroke_dasharray, stroke_dashoffset, color)
    color_class = "kt-gauge-progress kt-gauge-#{color}"
    content_tag(:circle, "", cx: 50, cy: 50, r: radius, class: color_class,
                       stroke_dasharray: stroke_dasharray, stroke_dashoffset: stroke_dashoffset,
                       transform: "rotate(-90 50 50)")
  end

  def gauge_semi_svg(gauge_id, percentage)
    radius = 40
    circumference = Math::PI * radius
    stroke_dasharray = circumference
    stroke_dashoffset = circumference - (percentage / 100.0) * circumference

    content_tag(:svg, class: "kt-gauge-semi-svg", width: 100, height: 60, viewBox: "0 0 100 60") do
      concat gauge_semi_background(radius)
      concat gauge_semi_progress(radius, stroke_dasharray, stroke_dashoffset)
    end
  end

  def gauge_semi_background(radius)
    content_tag(:path, "", d: semi_circle_path(radius), class: "kt-gauge-semi-bg")
  end

  def gauge_semi_progress(radius, stroke_dasharray, stroke_dashoffset)
    content_tag(:path, "", d: semi_circle_path(radius), class: "kt-gauge-semi-progress",
                       stroke_dasharray: stroke_dasharray, stroke_dashoffset: stroke_dashoffset)
  end

  def semi_circle_path(radius)
    "M #{50 - radius} 50 A #{radius} #{radius} 0 0 1 #{50 + radius} 50"
  end

  def gauge_content(value, max, label, percentage)
    content_tag(:div, class: "kt-gauge-content text-center") do
      concat content_tag(:div, "#{percentage}%", class: "kt-gauge-percentage text-2xl font-bold")
      concat content_tag(:div, label, class: "kt-gauge-label text-sm text-muted-foreground") if label
      concat content_tag(:div, "#{value}/#{max}", class: "kt-gauge-values text-xs text-muted-foreground")
    end
  end

  def meter_label(label)
    content_tag(:div, class: "kt-meter-label flex justify-between items-center mb-2") do
      concat content_tag(:span, label, class: "text-sm font-medium")
    end
  end

  def meter_bar(percentage, color)
    content_tag(:div, class: "kt-meter-bar w-full bg-muted rounded-full h-2") do
      content_tag(:div, "", class: "kt-meter-fill h-full rounded-full transition-all duration-300 #{meter_color_class(color)}",
                         style: "width: #{percentage}%")
    end
  end

  def meter_value(value, max, percentage)
    content_tag(:div, class: "kt-meter-value flex justify-between items-center mt-1") do
      concat content_tag(:span, "#{value}/#{max}", class: "text-xs text-muted-foreground")
      concat content_tag(:span, "#{percentage}%", class: "text-xs text-muted-foreground")
    end
  end

  def gauge_multi_svg(gauge_id, segments)
    # Multi-segment gauge would require more complex SVG paths
    content_tag(:div, "Multi-segment gauge placeholder", class: "p-4 text-center text-muted-foreground")
  end

  def gauge_multi_content(segments, label)
    content_tag(:div, class: "kt-gauge-multi-content text-center") do
      concat content_tag(:div, label, class: "text-sm font-medium mb-2") if label
      concat content_tag(:div, class: "flex justify-center gap-4 text-xs") do
        safe_join(segments.map do |segment|
          content_tag(:div, class: "flex items-center gap-1") do
            concat content_tag(:div, "", class: "w-3 h-3 rounded", style: "background-color: #{segment[:color]}")
            concat content_tag(:span, segment[:label])
          end
        end)
      end
    end
  end

  def determine_status(value, max, thresholds)
    percentage = calculate_percentage(value, max)

    case
    when thresholds[:danger] && percentage <= thresholds[:danger] then :danger
    when thresholds[:warning] && percentage <= thresholds[:warning] then :warning
    when thresholds[:success] && percentage >= thresholds[:success] then :success
    else :primary
    end
  end

  def build_gauge_class(size, additional_class)
    classes = ["kt-gauge", "relative inline-flex items-center justify-center"]

    case size
    when :sm then classes << "w-16 h-16"
    when :md then classes << "w-24 h-24"
    when :lg then classes << "w-32 h-32"
    else classes << "w-24 h-24"
    end

    classes << additional_class if additional_class
    classes.join(" ")
  end

  def build_gauge_semi_class(additional_class)
    classes = ["kt-gauge-semi", "relative inline-flex flex-col items-center"]
    classes << additional_class if additional_class
    classes.join(" ")
  end

  def build_meter_class(additional_class)
    classes = ["kt-meter"]
    classes << additional_class if additional_class
    classes.join(" ")
  end

  def build_gauge_multi_class(additional_class)
    classes = ["kt-gauge-multi", "relative inline-flex items-center justify-center"]
    classes << additional_class if additional_class
    classes.join(" ")
  end

  def meter_color_class(color)
    case color
    when :primary then "bg-primary"
    when :success then "bg-green-500"
    when :warning then "bg-yellow-500"
    when :danger then "bg-red-500"
    else "bg-primary"
    end
  end
end