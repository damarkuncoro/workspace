# app/helpers/kt/components/map_component.rb
module KT::Components::MapComponent
  include KT::BaseUiHelper

  # ✅ SRP: Basic map component
  def ui_map(center: [0, 0], zoom: 10, markers: [], **options)
    map_id = options[:id] || "map-#{SecureRandom.hex(4)}"
    classes = build_map_class(options.delete(:class))

    content_tag(:div, class: classes, **options) do
      concat map_container(map_id, center, zoom, markers)
      concat map_controls(map_id) if options[:controls]
    end
  end

  # ✅ SRP: Interactive map with markers
  def ui_map_with_markers(markers: [], center: nil, zoom: 10, **options)
    # Calculate center from markers if not provided
    center ||= calculate_center_from_markers(markers) if markers.any?
    center ||= [0, 0]

    ui_map(center: center, zoom: zoom, markers: markers, **options)
  end

  # ✅ SRP: Heatmap component
  def ui_heatmap(data: [], center: [0, 0], zoom: 10, **options)
    heatmap_id = options[:id] || "heatmap-#{SecureRandom.hex(4)}"
    classes = build_heatmap_class(options.delete(:class))

    content_tag(:div, class: classes, **options) do
      concat heatmap_container(heatmap_id, center, zoom, data)
      concat heatmap_legend if options[:show_legend]
    end
  end

  # ✅ SRP: Map with search
  def ui_map_with_search(center: [0, 0], zoom: 10, **options)
    map_id = options[:id] || "map-search-#{SecureRandom.hex(4)}"

    content_tag(:div, class: "kt-map-with-search") do
      concat map_search_input(map_id)
      concat ui_map(center: center, zoom: zoom, **options.merge(id: map_id))
    end
  end

  private

  def map_container(map_id, center, zoom, markers)
    map_data = {
      "kt-map": true,
      "kt-map-center": center.to_json,
      "kt-map-zoom": zoom,
      "kt-map-markers": markers.to_json
    }

    content_tag(:div, "", id: map_id, class: "kt-map-container", data: map_data)
  end

  def map_controls(map_id)
    content_tag(:div, class: "kt-map-controls", data: { "kt-map-controls": map_id }) do
      content_tag(:div, class: "kt-map-zoom-controls flex flex-col gap-1") do
        concat ui_button(text: "+", "data-kt-map-zoom-in": true, size: :sm)
        concat ui_button(text: "-", "data-kt-map-zoom-out": true, size: :sm)
      end
    end
  end

  def heatmap_container(heatmap_id, center, zoom, data)
    heatmap_data = {
      "kt-heatmap": true,
      "kt-heatmap-center": center.to_json,
      "kt-heatmap-zoom": zoom,
      "kt-heatmap-data": data.to_json
    }

    content_tag(:div, "", id: heatmap_id, class: "kt-heatmap-container", data: heatmap_data)
  end

  def heatmap_legend
    content_tag(:div, class: "kt-heatmap-legend") do
      content_tag(:div, class: "flex items-center gap-2 text-sm") do
        concat content_tag(:span, "Low", class: "text-muted-foreground")
        concat heatmap_gradient_bar
        concat content_tag(:span, "High", class: "text-muted-foreground")
      end
    end
  end

  def heatmap_gradient_bar
    content_tag(:div, class: "kt-heatmap-gradient flex-1 h-2 rounded", style: "background: linear-gradient(to right, #3B82F6, #EF4444)")
  end

  def map_search_input(map_id)
    content_tag(:div, class: "kt-map-search mb-4") do
      ui_autocomplete_remote(
        name: "map_search",
        url: "/api/places/search",
        placeholder: "Search for places...",
        data: { "kt-map-search": map_id }
      )
    end
  end

  def calculate_center_from_markers(markers)
    return [0, 0] if markers.empty?

    latitudes = markers.map { |m| m[:lat] || m[:position]&.first }.compact
    longitudes = markers.map { |m| m[:lng] || m[:position]&.last }.compact

    return [0, 0] if latitudes.empty? || longitudes.empty?

    center_lat = latitudes.sum / latitudes.size
    center_lng = longitudes.sum / longitudes.size

    [center_lat, center_lng]
  end

  def build_map_class(additional_class)
    classes = ["kt-map", "relative"]
    classes << additional_class if additional_class
    classes.join(" ")
  end

  def build_heatmap_class(additional_class)
    classes = ["kt-heatmap", "relative"]
    classes << additional_class if additional_class
    classes.join(" ")
  end
end