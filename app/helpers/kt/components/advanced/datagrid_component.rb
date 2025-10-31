# app/helpers/kt/components/datagrid_component.rb
module KT::Components::DatagridComponent
  include KT::UI::Base::BaseUIHelper

  # ✅ SRP: Basic data grid component
  def ui_data_grid(data: [], columns: [], **options)
    grid_id = options[:id] || "datagrid-#{SecureRandom.hex(4)}"
    classes = build_data_grid_class(options.delete(:class))

    content_tag(:div, class: classes, data: { "kt-data-grid": true }, **options) do
      concat data_grid_toolbar(grid_id, data.size)
      concat data_grid_table(data, columns, grid_id)
      concat data_grid_pagination(grid_id) if options[:pagination]
    end
  end

  # ✅ SRP: Data grid with filters
  def ui_data_grid_with_filters(data: [], columns: [], filters: [], **options)
    grid_id = options[:id] || "datagrid-filters-#{SecureRandom.hex(4)}"

    content_tag(:div, class: "kt-data-grid-with-filters") do
      concat data_grid_filters(filters, grid_id)
      concat ui_data_grid(data: data, columns: columns, **options.merge(id: grid_id))
    end
  end

  private

  def data_grid_toolbar(grid_id, total_count)
    content_tag(:div, class: "kt-data-grid-toolbar flex items-center justify-between p-4 border-b border-border") do
      concat data_grid_search(grid_id)
      concat data_grid_actions(grid_id, total_count)
    end
  end

  def data_grid_search(grid_id)
    content_tag(:div, class: "kt-data-grid-search") do
      ui_search_input(name: "search", placeholder: "Search...", data: { "kt-data-grid-search": grid_id })
    end
  end

  def data_grid_actions(grid_id, total_count)
    content_tag(:div, class: "kt-data-grid-actions flex items-center gap-2") do
      concat content_tag(:span, "#{total_count} items", class: "text-sm text-muted-foreground")
      concat data_grid_view_toggle(grid_id)
      concat data_grid_export_menu(grid_id)
    end
  end

  def data_grid_view_toggle(grid_id)
    content_tag(:div, class: "kt-data-grid-view-toggle flex border border-border rounded") do
      concat ui_button(icon: "list", variant: :ghost, size: :sm, class: "rounded-r-none", data: { "kt-data-grid-view": "table" })
      concat ui_button(icon: "grid", variant: :ghost, size: :sm, class: "rounded-l-none", data: { "kt-data-grid-view": "cards" })
    end
  end

  def data_grid_export_menu(grid_id)
    ui_context_menu(
      trigger: ui_button(icon: "download", variant: :outline, size: :sm),
      items: [
        { text: "Export CSV", icon: "file-text", href: "#", data: { "kt-data-grid-export": "csv" } },
        { text: "Export Excel", icon: "file-spreadsheet", href: "#", data: { "kt-data-grid-export": "xlsx" } },
        { text: "Export PDF", icon: "file", href: "#", data: { "kt-data-grid-export": "pdf" } }
      ]
    )
  end

  def data_grid_filters(filters, grid_id)
    content_tag(:div, class: "kt-data-grid-filters p-4 border-b border-border bg-muted/25") do
      content_tag(:div, class: "flex flex-wrap gap-4") do
        safe_join(filters.map { |filter| data_grid_filter(filter, grid_id) })
      end
    end
  end

  def data_grid_filter(filter, grid_id)
    case filter[:type]
    when :select
      select_tag(filter[:name], options_for_select(filter[:options]), class: "kt-input", data: { "kt-data-grid-filter": grid_id })
    when :date_range
      ui_datepicker_range(start_name: "#{filter[:name]}_start", end_name: "#{filter[:name]}_end")
    when :checkbox
      check_box_tag(filter[:name], "1", filter[:checked], class: "kt-switch", data: { "kt-data-grid-filter": grid_id })
    else
      text_field_tag(filter[:name], filter[:value], placeholder: filter[:placeholder], class: "kt-input", data: { "kt-data-grid-filter": grid_id })
    end
  end

  def data_grid_table(data, columns, grid_id)
    content_tag(:div, class: "kt-data-grid-table overflow-x-auto") do
      ui_table(headers: columns, rows: data.map { |row| format_row_data(row, columns) }, data: { "kt-data-grid-table": grid_id })
    end
  end

  def format_row_data(row, columns)
    columns.map do |column|
      value = row[column[:key]]
      format_cell_value(value, column)
    end
  end

  def format_cell_value(value, column)
    case column[:type]
    when :badge
      ui_badge(text: value, variant: column[:variant] || :default)
    when :avatar
      ui_avatar(src: value[:src], alt: value[:alt], size: :sm)
    when :date
      l(value) if value.present?
    when :currency
      number_to_currency(value)
    when :boolean
      ui_icon(name: value ? "check" : "x", size: :sm, wrapper_class: value ? "text-green-500" : "text-red-500")
    else
      value
    end
  end

  def data_grid_pagination(grid_id)
    content_tag(:div, class: "kt-data-grid-pagination p-4 border-t border-border") do
      ui_pagination(current_page: 1, total_pages: 5, data: { "kt-data-grid-pagination": grid_id })
    end
  end

  def build_data_grid_class(additional_class)
    classes = [ "kt-data-grid", "border border-border rounded-lg bg-background" ]
    classes << additional_class if additional_class
    classes.join(" ")
  end
end
