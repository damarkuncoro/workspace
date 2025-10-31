# app/helpers/kt/components/pagination_component.rb
module KT::Components::PaginationComponent
  include KT::BaseUiHelper

  # ✅ SRP: Main pagination component
  def ui_pagination(current_page:, total_pages:, **options)
    return "" if total_pages <= 1

    pagination_data = build_pagination_data(current_page, total_pages)
    classes = build_pagination_classes(options.delete(:variant) || :default, options.delete(:size) || :md)

    content_tag(:nav, class: classes, **options.merge("aria-label": "Pagination")) do
      content_tag(:ul, class: "kt-pagination-list flex items-center gap-1") do
        safe_join(pagination_data.map { |item| pagination_item(item, current_page) })
      end
    end
  end

  # ✅ SRP: Compact pagination (previous/next only)
  def ui_pagination_simple(current_page:, total_pages:, **options)
    return "" if total_pages <= 1

    classes = build_pagination_classes(:simple, options.delete(:size) || :md)

    content_tag(:nav, class: classes, **options.merge("aria-label": "Pagination")) do
      content_tag(:ul, class: "kt-pagination-list flex items-center gap-2") do
        safe_join([
          pagination_prev_button(current_page, total_pages),
          pagination_next_button(current_page, total_pages)
        ])
      end
    end
  end

  # ✅ SRP: Pagination with page size selector
  def ui_pagination_with_size(current_page:, total_pages:, page_size:, page_sizes: [10, 25, 50, 100], **options)
    content_tag(:div, class: "flex items-center justify-between gap-4") do
      concat ui_pagination(current_page: current_page, total_pages: total_pages, **options)
      concat pagination_size_selector(page_size, page_sizes)
    end
  end

  private

  def build_pagination_data(current_page, total_pages)
    pages = []

    # Previous button
    pages << { type: :prev, page: current_page - 1, disabled: current_page == 1 }

    # Calculate visible page numbers
    visible_pages = calculate_visible_pages(current_page, total_pages)

    # Add page numbers
    visible_pages.each do |page|
      if page.is_a?(Integer)
        pages << { type: :page, page: page, active: page == current_page }
      else
        pages << { type: :ellipsis, symbol: page }
      end
    end

    # Next button
    pages << { type: :next, page: current_page + 1, disabled: current_page == total_pages }

    pages
  end

  def calculate_visible_pages(current_page, total_pages)
    return (1..total_pages).to_a if total_pages <= 7

    pages = []

    # Always show first page
    pages << 1

    if current_page > 4
      pages << "..."
    end

    # Show pages around current page
    start_page = [2, current_page - 1].max
    end_page = [total_pages - 1, current_page + 1].min

    (start_page..end_page).each do |page|
      pages << page
    end

    if current_page < total_pages - 3
      pages << "..."
    end

    # Always show last page
    pages << total_pages if total_pages > 1

    pages.uniq
  end

  def pagination_item(item, current_page)
    content_tag(:li) do
      case item[:type]
      when :page then pagination_page_button(item)
      when :prev then pagination_prev_button(current_page, item[:page])
      when :next then pagination_next_button(current_page, item[:page])
      when :ellipsis then pagination_ellipsis
      end
    end
  end

  def pagination_page_button(item)
    link_class = build_pagination_link_class(item[:active])
    link_to(item[:page], "?page=#{item[:page]}", class: link_class, "aria-current": item[:active] ? "page" : nil)
  end

  def pagination_prev_button(current_page, target_page)
    disabled = current_page == 1
    link_class = build_pagination_link_class(false, disabled)

    if disabled
      content_tag(:span, class: link_class, "aria-disabled": true) do
        ui_icon(name: "chevron-left", size: :sm)
      end
    else
      link_to("?page=#{target_page}", class: link_class, "aria-label": "Previous page") do
        ui_icon(name: "chevron-left", size: :sm)
      end
    end
  end

  def pagination_next_button(current_page, target_page)
    disabled = current_page == target_page - 1
    link_class = build_pagination_link_class(false, disabled)

    if disabled
      content_tag(:span, class: link_class, "aria-disabled": true) do
        ui_icon(name: "chevron-right", size: :sm)
      end
    else
      link_to("?page=#{target_page}", class: link_class, "aria-label": "Next page") do
        ui_icon(name: "chevron-right", size: :sm)
      end
    end
  end

  def pagination_ellipsis
    content_tag(:span, "...", class: "kt-pagination-ellipsis px-3 py-2 text-muted-foreground", "aria-hidden": true)
  end

  def pagination_size_selector(current_size, sizes)
    content_tag(:div, class: "flex items-center gap-2 text-sm") do
      concat content_tag(:span, "Show:", class: "text-muted-foreground")
      concat select_tag(:per_page, options_for_select(sizes, current_size), class: "kt-select text-sm", onchange: "this.form.submit()")
    end
  end

  def build_pagination_classes(variant, size)
    classes = ["kt-pagination"]

    case variant
    when :simple then classes << "kt-pagination-simple"
    else classes << "kt-pagination-default"
    end

    case size
    when :sm then classes << "kt-pagination-sm"
    when :lg then classes << "kt-pagination-lg"
    else classes << "kt-pagination-md"
    end

    classes.join(" ")
  end

  def build_pagination_link_class(active, disabled = false)
    classes = ["kt-pagination-link"]

    if active
      classes << "kt-pagination-link-active bg-primary text-primary-foreground"
    elsif disabled
      classes << "kt-pagination-link-disabled opacity-50 cursor-not-allowed"
    else
      classes << "kt-pagination-link-default hover:bg-accent hover:text-accent-foreground"
    end

    classes.join(" ")
  end
end