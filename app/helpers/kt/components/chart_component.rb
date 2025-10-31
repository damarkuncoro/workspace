# app/helpers/kt/components/chart_component.rb
module KT::Components::ChartComponent
  include KT::BaseUiHelper

  # ✅ SRP: Basic chart component
  def ui_chart(type:, data:, options: {}, **html_options)
    chart_id = html_options[:id] || "chart-#{SecureRandom.hex(4)}"
    classes = build_chart_class(html_options.delete(:class))

    content_tag(:div, class: classes, **html_options) do
      concat chart_canvas(chart_id, type, data, options)
      concat chart_legend(data[:datasets]) if data[:show_legend]
    end
  end

  # ✅ SRP: Bar chart
  def ui_bar_chart(data:, options: {}, **html_options)
    ui_chart(type: :bar, data: data, options: options, **html_options)
  end

  # ✅ SRP: Line chart
  def ui_line_chart(data:, options: {}, **html_options)
    ui_chart(type: :line, data: data, options: options, **html_options)
  end

  # ✅ SRP: Pie chart
  def ui_pie_chart(data:, options: {}, **html_options)
    ui_chart(type: :pie, data: data, options: options, **html_options)
  end

  # ✅ SRP: Doughnut chart
  def ui_doughnut_chart(data:, options: {}, **html_options)
    ui_chart(type: :doughnut, data: data, options: options, **html_options)
  end

  # ✅ SRP: Radar chart
  def ui_radar_chart(data:, options: {}, **html_options)
    ui_chart(type: :radar, data: data, options: options, **html_options)
  end

  # ✅ SRP: Area chart
  def ui_area_chart(data:, options: {}, **html_options)
    options = options.merge(fill: true)
    ui_chart(type: :line, data: data, options: options, **html_options)
  end

  # ✅ SRP: Chart with controls
  def ui_chart_with_controls(type:, data:, controls: [], **html_options)
    chart_id = html_options[:id] || "chart-controls-#{SecureRandom.hex(4)}"

    content_tag(:div, class: "kt-chart-with-controls") do
      concat chart_controls(controls, chart_id)
      concat ui_chart(type: type, data: data, **html_options.merge(id: chart_id))
    end
  end

  private

  def chart_canvas(chart_id, type, data, options)
    canvas_data = {
      "kt-chart": true,
      "kt-chart-type": type,
      "kt-chart-data": data.to_json,
      "kt-chart-options": options.to_json
    }

    content_tag(:canvas, "", id: chart_id, data: canvas_data)
  end

  def chart_legend(datasets)
    return "" unless datasets

    content_tag(:div, class: "kt-chart-legend flex flex-wrap gap-4 mt-4") do
      safe_join(datasets.map.with_index do |dataset, index|
        content_tag(:div, class: "kt-chart-legend-item flex items-center gap-2") do
          concat chart_legend_color(dataset, index)
          concat content_tag(:span, dataset[:label] || "Dataset #{index + 1}", class: "text-sm")
        end
      end)
    end
  end

  def chart_legend_color(dataset, index)
    color = dataset[:backgroundColor] || dataset[:borderColor] || default_chart_colors[index % default_chart_colors.length]
    content_tag(:div, "", class: "kt-chart-legend-color w-3 h-3 rounded", style: "background-color: #{color}")
  end

  def chart_controls(controls, chart_id)
    content_tag(:div, class: "kt-chart-controls flex items-center gap-2 mb-4", data: { "kt-chart-controls": chart_id }) do
      safe_join(controls.map { |control| control.respond_to?(:call) ? control.call : control })
    end
  end

  def default_chart_colors
    [
      "#3B82F6", # blue
      "#EF4444", # red
      "#10B981", # green
      "#F59E0B", # yellow
      "#8B5CF6", # purple
      "#06B6D4", # cyan
      "#F97316", # orange
      "#84CC16"  # lime
    ]
  end

  def build_chart_class(additional_class)
    classes = ["kt-chart"]
    classes << additional_class if additional_class
    classes.join(" ")
  end
end