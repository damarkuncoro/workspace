# app/helpers/kt/components/kanbanboard_component.rb
module KT::Components::KanbanboardComponent
  include KT::UI::Base::BaseUIHelper

  # ✅ SRP: Basic kanban board component
  def ui_kanban_board(columns: [], **options)
    board_id = options[:id] || "kanban-#{SecureRandom.hex(4)}"
    classes = build_kanban_board_class(options.delete(:class))

    content_tag(:div, class: classes, data: { "kt-kanban-board": true }, **options) do
      safe_join(columns.map { |column| kanban_column(column, board_id) })
    end
  end

  # ✅ SRP: Kanban column component
  def ui_kanban_column(title:, cards: [], limit: nil, **options)
    column_id = options[:id] || "column-#{SecureRandom.hex(4)}"
    classes = build_kanban_column_class(options.delete(:class))

    content_tag(:div, class: classes, data: { "kt-kanban-column": true, "kt-kanban-column-id": column_id }, **options) do
      concat kanban_column_header(title, cards.size, limit)
      concat kanban_column_cards(cards, column_id)
      concat kanban_column_footer(column_id)
    end
  end

  # ✅ SRP: Kanban card component
  def ui_kanban_card(card:, **options)
    card_id = options[:id] || "card-#{SecureRandom.hex(4)}"
    classes = build_kanban_card_class(card[:priority], options.delete(:class))

    content_tag(:div, class: classes, data: { "kt-kanban-card": true, "kt-kanban-card-id": card_id }, **options) do
      concat kanban_card_header(card)
      concat kanban_card_content(card)
      concat kanban_card_footer(card)
    end
  end

  private

  def kanban_column(column_data, board_id)
    ui_kanban_column(**column_data.merge(id: "#{board_id}-#{column_data[:id] || SecureRandom.hex(4)}"))
  end

  def kanban_column_header(title, count, limit)
    content_tag(:div, class: "kt-kanban-column-header flex items-center justify-between p-4 border-b border-border") do
      concat content_tag(:h3, title, class: "kt-kanban-column-title font-medium text-sm")
      concat kanban_column_count(count, limit)
    end
  end

  def kanban_column_count(count, limit)
    content_tag(:div, class: "kt-kanban-column-count flex items-center gap-2") do
      concat content_tag(:span, count, class: "kt-kanban-count-badge bg-muted text-muted-foreground px-2 py-1 rounded text-xs font-medium")
      concat content_tag(:span, "/#{limit}", class: "text-xs text-muted-foreground") if limit
    end
  end

  def kanban_column_cards(cards, column_id)
    content_tag(:div, class: "kt-kanban-column-cards p-2 space-y-3 min-h-[200px]", data: { "kt-kanban-cards": column_id }) do
      safe_join(cards.map { |card| ui_kanban_card(card: card) })
    end
  end

  def kanban_column_footer(column_id)
    content_tag(:div, class: "kt-kanban-column-footer p-4 border-t border-border") do
      ui_button(text: "Add Card", variant: :ghost, size: :sm, class: "w-full", data: { "kt-kanban-add-card": column_id })
    end
  end

  def kanban_card_header(card)
    content_tag(:div, class: "kt-kanban-card-header flex items-center justify-between mb-3") do
      concat kanban_card_labels(card[:labels]) if card[:labels]
      concat kanban_card_menu(card[:id])
    end
  end

  def kanban_card_labels(labels)
    content_tag(:div, class: "kt-kanban-card-labels flex gap-1") do
      safe_join(labels.map { |label| ui_badge(text: label[:text], variant: label[:color] || :default, size: :xs) })
    end
  end

  def kanban_card_menu(card_id)
    ui_context_menu(
      trigger: ui_icon_button(icon: "more-vertical", size: :xs, variant: :ghost),
      items: [
        { text: "Edit", icon: "edit", href: "#", data: { "kt-kanban-edit-card": card_id } },
        { text: "Move", icon: "arrow-right", href: "#", data: { "kt-kanban-move-card": card_id } },
        { divider: true },
        { text: "Delete", icon: "trash", href: "#", data: { "kt-kanban-delete-card": card_id } }
      ]
    )
  end

  def kanban_card_content(card)
    content_tag(:div, class: "kt-kanban-card-content") do
      concat content_tag(:h4, card[:title], class: "kt-kanban-card-title font-medium text-sm mb-2 line-clamp-2")
      concat content_tag(:p, card[:description], class: "kt-kanban-card-description text-xs text-muted-foreground line-clamp-3") if card[:description]
    end
  end

  def kanban_card_footer(card)
    return "" unless card[:assignee] || card[:due_date] || card[:comments]

    content_tag(:div, class: "kt-kanban-card-footer flex items-center justify-between mt-3 pt-3 border-t border-border") do
      concat kanban_card_assignee(card[:assignee]) if card[:assignee]
      concat kanban_card_meta(card)
    end
  end

  def kanban_card_assignee(assignee)
    content_tag(:div, class: "kt-kanban-card-assignee") do
      ui_avatar(src: assignee[:avatar], alt: assignee[:name], size: :xs)
    end
  end

  def kanban_card_meta(card)
    content_tag(:div, class: "kt-kanban-card-meta flex items-center gap-2") do
      concat kanban_card_due_date(card[:due_date]) if card[:due_date]
      concat kanban_card_comments(card[:comments]) if card[:comments]
    end
  end

  def kanban_card_due_date(due_date)
    content_tag(:div, class: "kt-kanban-card-due-date flex items-center gap-1 text-xs text-muted-foreground") do
      concat ui_icon(name: "calendar", size: :xs)
      concat content_tag(:span, due_date)
    end
  end

  def kanban_card_comments(count)
    content_tag(:div, class: "kt-kanban-card-comments flex items-center gap-1 text-xs text-muted-foreground") do
      concat ui_icon(name: "message-circle", size: :xs)
      concat content_tag(:span, count)
    end
  end

  def build_kanban_board_class(additional_class)
    classes = [ "kt-kanban-board", "flex gap-6 overflow-x-auto pb-6" ]
    classes << additional_class if additional_class
    classes.join(" ")
  end

  def build_kanban_column_class(additional_class)
    classes = [ "kt-kanban-column", "bg-muted/50 rounded-lg border border-border min-w-[300px] max-w-[300px]" ]
    classes << additional_class if additional_class
    classes.join(" ")
  end

  def build_kanban_card_class(priority, additional_class)
    classes = [ "kt-kanban-card", "bg-background border border-border rounded-lg p-4 shadow-sm hover:shadow-md transition-shadow cursor-pointer" ]

    priority_class = case priority
    when :high then "border-l-4 border-l-red-500"
    when :medium then "border-l-4 border-l-yellow-500"
    when :low then "border-l-4 border-l-green-500"
    else ""
    end
    classes << priority_class if priority_class.present?

    classes << additional_class if additional_class
    classes.join(" ")
  end
end
