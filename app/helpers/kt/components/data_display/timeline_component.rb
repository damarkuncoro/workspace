# app/helpers/kt/components/timeline_component.rb
module KT::Components::TimelineComponent
  include KT::UI::Base::BaseUIHelper

  # ✅ SRP: Basic timeline component
  def ui_timeline(items: [], variant: :default, **options)
    classes = build_timeline_class(variant)
    content_tag(:div, class: classes, **options) do
      safe_join(items.map { |item| timeline_item(item, variant) })
    end
  end

  # ✅ SRP: Timeline with connector lines
  def ui_timeline_connected(items: [], variant: :default, **options)
    classes = build_timeline_connected_class(variant)
    content_tag(:div, class: classes, **options) do
      safe_join(items.each_with_index.map { |item, index| timeline_connected_item(item, index, items.size - 1, variant) })
    end
  end

  # ✅ SRP: Compact timeline
  def ui_timeline_compact(items: [], **options)
    ui_timeline(items: items, variant: :compact, **options)
  end

  private

  def timeline_item(item, variant)
    content_tag(:div, class: "kt-timeline-item") do
      content_tag(:div, class: "flex gap-4") do
        concat timeline_marker(item[:status])
        concat timeline_content(item)
      end
    end
  end

  def timeline_connected_item(item, index, last_index, variant)
    is_last = index == last_index
    content_tag(:div, class: "kt-timeline-connected-item #{is_last ? 'last' : ''}") do
      content_tag(:div, class: "flex gap-4") do
        concat timeline_connector(index, last_index)
        concat timeline_marker(item[:status])
        concat timeline_content(item)
      end
    end
  end

  def timeline_marker(status)
    marker_class = build_marker_class(status)
    content_tag(:div, class: "kt-timeline-marker #{marker_class}") do
      timeline_marker_icon(status)
    end
  end

  def timeline_marker_icon(status)
    icon_name = case status.to_sym
    when :completed, :success then "check"
    when :error, :failed then "x"
    when :warning then "alert-triangle"
    when :info then "info"
    when :pending then "clock"
    else "circle"
    end
    ui_icon(name: icon_name, size: :sm)
  end

  def timeline_connector(index, last_index)
    connector_class = index == last_index ? "kt-timeline-connector-last" : "kt-timeline-connector"
    content_tag(:div, class: connector_class)
  end

  def timeline_content(item)
    content_tag(:div, class: "kt-timeline-content flex-1") do
      concat timeline_header(item)
      concat timeline_body(item) if item[:body]
      concat timeline_footer(item) if item[:footer]
    end
  end

  def timeline_header(item)
    content_tag(:div, class: "kt-timeline-header") do
      content_tag(:div, class: "flex items-center justify-between") do
        concat content_tag(:h4, item[:title], class: "kt-timeline-title") if item[:title]
        concat content_tag(:time, item[:time], class: "kt-timeline-time text-sm text-muted-foreground") if item[:time]
      end
    end
  end

  def timeline_body(item)
    content_tag(:div, class: "kt-timeline-body mt-2") do
      content_tag(:p, item[:body], class: "text-sm text-muted-foreground")
    end
  end

  def timeline_footer(item)
    content_tag(:div, class: "kt-timeline-footer mt-2") do
      if item[:footer].is_a?(Array)
        content_tag(:div, class: "flex gap-2") do
          safe_join(item[:footer].map { |action| action.respond_to?(:call) ? action.call : action })
        end
      else
        item[:footer]
      end
    end
  end

  def build_timeline_class(variant)
    classes = [ "kt-timeline" ]

    case variant
    when :compact then classes << "kt-timeline-compact"
    when :bordered then classes << "kt-timeline-bordered"
    else classes << "kt-timeline-default"
    end

    classes.join(" ")
  end

  def build_timeline_connected_class(variant)
    classes = [ "kt-timeline-connected" ]

    case variant
    when :compact then classes << "kt-timeline-connected-compact"
    else classes << "kt-timeline-connected-default"
    end

    classes.join(" ")
  end

  def build_marker_class(status)
    base_class = "kt-timeline-marker"

    status_class = case status.to_sym
    when :completed, :success then "kt-timeline-marker-success"
    when :error, :failed then "kt-timeline-marker-error"
    when :warning then "kt-timeline-marker-warning"
    when :info then "kt-timeline-marker-info"
    when :pending then "kt-timeline-marker-pending"
    else "kt-timeline-marker-default"
    end

    "#{base_class} #{status_class}"
  end
end
