# app/helpers/kt/components/progress_component.rb
module KT::Components::ProgressComponent
  include KT::UI::Base::BaseUIHelper

  # ✅ SRP: Basic progress bar
  def ui_progress(value:, max: 100, variant: :default, size: :md, show_label: false, **options)
    percentage = calculate_percentage(value, max)
    classes = build_progress_class(variant, size)

    content_tag(:div, class: classes, **options) do
      concat progress_bar(percentage, variant)
      concat progress_label(percentage) if show_label
    end
  end

  # ✅ SRP: Circular progress
  def ui_progress_circle(value:, max: 100, size: :md, show_label: false, **options)
    percentage = calculate_percentage(value, max)
    classes = build_progress_circle_class(size)

    content_tag(:div, class: classes, **options) do
      concat progress_circle_svg(percentage)
      concat progress_circle_label(percentage) if show_label
    end
  end

  # ✅ SRP: Progress with steps
  def ui_progress_steps(current:, total:, steps: [], **options)
    content_tag(:div, class: "kt-progress-steps", **options) do
      content_tag(:div, class: "flex items-center") do
        safe_join((1..total).map { |step| progress_step(step, current, steps[step - 1]) })
      end
    end
  end

  # ✅ SRP: Multiple progress bars
  def ui_progress_stacked(bars: [], **options)
    content_tag(:div, class: "kt-progress-stacked space-y-2", **options) do
      safe_join(bars.map { |bar| ui_progress(**bar) })
    end
  end

  private

  def calculate_percentage(value, max)
    [ (value.to_f / max.to_f * 100).round, 100 ].min
  end

  def progress_bar(percentage, variant)
    content_tag(:div, class: "kt-progress-bar") do
      content_tag(:div, "", class: "kt-progress-fill #{progress_fill_class(variant)}", style: "width: #{percentage}%")
    end
  end

  def progress_label(percentage)
    content_tag(:span, "#{percentage}%", class: "kt-progress-label text-sm ml-2")
  end

  def progress_circle_svg(percentage)
    radius = 40
    circumference = 2 * Math::PI * radius
    stroke_dasharray = circumference
    stroke_dashoffset = circumference - (percentage / 100.0) * circumference

    content_tag(:svg, class: "kt-progress-circle-svg", width: 100, height: 100, viewBox: "0 0 100 100") do
      concat content_tag(:circle, "", cx: 50, cy: 50, r: radius, class: "kt-progress-circle-bg")
      concat content_tag(:circle, "", cx: 50, cy: 50, r: radius, class: "kt-progress-circle-fill",
                         stroke_dasharray: stroke_dasharray, stroke_dashoffset: stroke_dashoffset)
    end
  end

  def progress_circle_label(percentage)
    content_tag(:div, class: "kt-progress-circle-label") do
      content_tag(:span, "#{percentage}%", class: "text-lg font-semibold")
    end
  end

  def progress_step(step, current, label = nil)
    is_completed = step < current
    is_current = step == current

    classes = [ "kt-progress-step" ]
    classes << "completed" if is_completed
    classes << "current" if is_current

    content_tag(:div, class: classes.join(" ")) do
      concat progress_step_indicator(is_completed, is_current)
      concat progress_step_label(label) if label
    end
  end

  def progress_step_indicator(is_completed, is_current)
    content_tag(:div, class: "kt-progress-step-indicator") do
      if is_completed
        ui_icon(name: "check", size: :xs)
      elsif is_current
        content_tag(:div, "", class: "kt-progress-step-current")
      else
        content_tag(:div, "", class: "kt-progress-step-upcoming")
      end
    end
  end

  def progress_step_label(label)
    content_tag(:span, label, class: "kt-progress-step-label text-sm ml-2")
  end

  def build_progress_class(variant, size)
    classes = [ "kt-progress" ]

    case variant
    when :primary then classes << "kt-progress-primary"
    when :success then classes << "kt-progress-success"
    when :warning then classes << "kt-progress-warning"
    when :danger then classes << "kt-progress-danger"
    else classes << "kt-progress-default"
    end

    case size
    when :sm then classes << "kt-progress-sm"
    when :lg then classes << "kt-progress-lg"
    else classes << "kt-progress-md"
    end

    classes.join(" ")
  end

  def build_progress_circle_class(size)
    classes = [ "kt-progress-circle" ]

    case size
    when :sm then classes << "kt-progress-circle-sm"
    when :lg then classes << "kt-progress-circle-lg"
    else classes << "kt-progress-circle-md"
    end

    classes.join(" ")
  end

  def progress_fill_class(variant)
    case variant
    when :primary then "kt-progress-fill-primary"
    when :success then "kt-progress-fill-success"
    when :warning then "kt-progress-fill-warning"
    when :danger then "kt-progress-fill-danger"
    else "kt-progress-fill-default"
    end
  end
end
