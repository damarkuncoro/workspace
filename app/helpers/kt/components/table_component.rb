# app/helpers/kt/components/table_component.rb
module KT::Components::TableComponent
  include KT::BaseUiHelper

  # ✅ SRP: Basic table component
  def ui_table(headers: [], rows: [], variant: :default, size: :md, striped: false, hover: false, **options)
    table_class = build_table_class(variant, size, striped, hover)

    content_tag(:div, class: "kt-table-wrapper", **options) do
      content_tag(:table, class: table_class) do
        concat table_head(headers) if headers.any?
        concat table_body(rows) if rows.any?
      end
    end
  end

  # ✅ SRP: Sortable table
  def ui_table_sortable(headers: [], rows: [], sort_column: nil, sort_direction: :asc, **options)
    ui_table(headers: headers, rows: rows, **options) do
      # Custom headers with sort indicators
      headers.map do |header|
        sortable_header(header, sort_column, sort_direction)
      end
    end
  end

  # ✅ SRP: Data table with pagination
  def ui_data_table(headers: [], rows: [], pagination: {}, **options)
    content_tag(:div, class: "kt-data-table") do
      concat ui_table(headers: headers, rows: rows, **options)
      concat ui_pagination(**pagination) if pagination.any?
    end
  end

  # ✅ SRP: Table with actions column
  def ui_table_with_actions(headers: [], rows: [], actions: [], **options)
    # Add actions header
    headers_with_actions = headers + [{ title: "Actions", class: "w-32" }]

    # Add actions to each row
    rows_with_actions = rows.map do |row|
      row + [table_actions_cell(actions)]
    end

    ui_table(headers: headers_with_actions, rows: rows_with_actions, **options)
  end

  private

  def table_head(headers)
    content_tag(:thead, class: "kt-table-head") do
      content_tag(:tr) do
        safe_join(headers.map { |header| table_header_cell(header) })
      end
    end
  end

  def table_header_cell(header)
    cell_class = ["kt-table-header", header[:class]].compact.join(" ")
    content_tag(:th, header[:title] || header, class: cell_class)
  end

  def sortable_header(header, sort_column, sort_direction)
    is_sorted = header[:column] == sort_column
    sort_icon = is_sorted ? (sort_direction == :asc ? "chevron-up" : "chevron-down") : "chevron-up-down"

    content_tag(:th, class: "kt-table-header sortable #{is_sorted ? 'sorted' : ''}") do
      link_to("#", class: "flex items-center gap-2", data: { column: header[:column] }) do
        concat header[:title]
        concat ui_icon(name: sort_icon, size: :xs)
      end
    end
  end

  def table_body(rows)
    content_tag(:tbody, class: "kt-table-body") do
      safe_join(rows.map { |row| table_row(row) })
    end
  end

  def table_row(row)
    content_tag(:tr, class: "kt-table-row") do
      safe_join(row.map { |cell| table_cell(cell) })
    end
  end

  def table_cell(cell)
    if cell.is_a?(Hash)
      cell_class = ["kt-table-cell", cell[:class]].compact.join(" ")
      content_tag(:td, cell[:content], class: cell_class)
    else
      content_tag(:td, cell, class: "kt-table-cell")
    end
  end

  def table_actions_cell(actions)
    content_tag(:td, class: "kt-table-cell") do
      ui_action_menu(actions: actions, size: :sm)
    end
  end

  def build_table_class(variant, size, striped, hover)
    classes = ["kt-table"]

    case variant
    when :bordered then classes << "kt-table-bordered"
    when :borderless then classes << "kt-table-borderless"
    else classes << "kt-table-default"
    end

    case size
    when :sm then classes << "kt-table-sm"
    when :lg then classes << "kt-table-lg"
    else classes << "kt-table-md"
    end

    classes << "kt-table-striped" if striped
    classes << "kt-table-hover" if hover

    classes.join(" ")
  end
end