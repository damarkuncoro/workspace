# app/helpers/kt/components/richtexteditor_component.rb
module KT::Components::RichtexteditorComponent
  include KT::UI::Base::BaseUIHelper

  # ✅ SRP: Basic rich text editor component
  def ui_rich_text_editor(name:, value: "", toolbar: :basic, **options)
    editor_id = options[:id] || "editor-#{SecureRandom.hex(4)}"
    classes = build_rich_text_editor_class(options.delete(:class))

    content_tag(:div, class: "kt-rich-text-editor", **options) do
      concat rich_text_editor_toolbar(editor_id, toolbar)
      concat rich_text_editor_content(name, value, editor_id, classes)
    end
  end

  # ✅ SRP: Markdown editor component
  def ui_markdown_editor(name:, value: "", preview: false, **options)
    editor_id = options[:id] || "markdown-#{SecureRandom.hex(4)}"
    classes = build_markdown_editor_class(options.delete(:class))

    content_tag(:div, class: "kt-markdown-editor", **options) do
      if preview
        concat markdown_editor_tabs(editor_id)
        concat markdown_editor_panels(name, value, editor_id, classes)
      else
        concat markdown_editor_content(name, value, editor_id, classes)
      end
      concat markdown_editor_toolbar(editor_id)
    end
  end

  private

  def rich_text_editor_toolbar(editor_id, toolbar)
    toolbar_items = get_toolbar_items(toolbar)

    content_tag(:div, class: "kt-rich-text-toolbar flex flex-wrap gap-1 p-2 border-b border-border bg-muted/25") do
      safe_join(toolbar_items.map { |item| toolbar_button(item, editor_id) })
    end
  end

  def toolbar_button(item, editor_id)
    if item[:divider]
      content_tag(:div, "", class: "kt-toolbar-divider w-px h-6 bg-border mx-2")
    elsif item[:dropdown]
      toolbar_dropdown(item, editor_id)
    else
      ui_button(
        icon: item[:icon],
        variant: :ghost,
        size: :sm,
        class: "kt-toolbar-btn",
        data: { "kt-editor-action": item[:action], "kt-editor-target": editor_id },
        title: item[:title]
      )
    end
  end

  def toolbar_dropdown(item, editor_id)
    ui_context_menu(
      trigger: ui_button(icon: item[:icon], variant: :ghost, size: :sm, class: "kt-toolbar-btn"),
      items: item[:items].map { |sub_item| sub_item.merge(data: { "kt-editor-action": sub_item[:action], "kt-editor-target": editor_id }) }
    )
  end

  def rich_text_editor_content(name, value, editor_id, classes)
    content_tag(:div, class: "kt-rich-text-content") do
      hidden_field_tag(name, value, data: { "kt-editor-hidden": editor_id })
      content_tag(:div, value.html_safe, class: classes, contenteditable: true,
                  data: { "kt-editor-content": true, "kt-editor-id": editor_id })
    end
  end

  def markdown_editor_tabs(editor_id)
    content_tag(:div, class: "kt-markdown-tabs flex border-b border-border") do
      concat content_tag(:button, "Write", class: "kt-markdown-tab px-4 py-2 border-b-2 border-primary text-primary", data: { "kt-markdown-tab": "write" })
      concat content_tag(:button, "Preview", class: "kt-markdown-tab px-4 py-2", data: { "kt-markdown-tab": "preview" })
    end
  end

  def markdown_editor_panels(name, value, editor_id, classes)
    content_tag(:div, class: "kt-markdown-panels") do
      concat content_tag(:div, class: "kt-markdown-panel kt-markdown-write active") do
        text_area_tag(name, value, class: classes, data: { "kt-markdown-editor": editor_id })
      end
      concat content_tag(:div, class: "kt-markdown-panel kt-markdown-preview hidden", data: { "kt-markdown-preview": editor_id })
    end
  end

  def markdown_editor_content(name, value, editor_id, classes)
    text_area_tag(name, value, class: classes, data: { "kt-markdown-editor": editor_id })
  end

  def markdown_editor_toolbar(editor_id)
    content_tag(:div, class: "kt-markdown-toolbar flex flex-wrap gap-1 p-2 border-t border-border bg-muted/25") do
      safe_join([
        toolbar_button({ icon: "bold", action: "bold", title: "Bold" }, editor_id),
        toolbar_button({ icon: "italic", action: "italic", title: "Italic" }, editor_id),
        toolbar_button({ icon: "link", action: "link", title: "Link" }, editor_id),
        toolbar_button({ icon: "list", action: "list", title: "List" }, editor_id),
        toolbar_button({ icon: "code", action: "code", title: "Code" }, editor_id),
        toolbar_button({ icon: "image", action: "image", title: "Image" }, editor_id)
      ])
    end
  end

  def get_toolbar_items(toolbar)
    case toolbar
    when :basic
      [
        { icon: "bold", action: "bold", title: "Bold" },
        { icon: "italic", action: "italic", title: "Italic" },
        { icon: "underline", action: "underline", title: "Underline" },
        { divider: true },
        { icon: "list", action: "list", title: "Bullet List" },
        { icon: "list-ordered", action: "list-ordered", title: "Numbered List" },
        { divider: true },
        { icon: "link", action: "link", title: "Insert Link" },
        { icon: "image", action: "image", title: "Insert Image" }
      ]
    when :full
      [
        { icon: "bold", action: "bold", title: "Bold" },
        { icon: "italic", action: "italic", title: "Italic" },
        { icon: "underline", action: "underline", title: "Underline" },
        { icon: "strikethrough", action: "strikethrough", title: "Strikethrough" },
        { divider: true },
        { icon: "align-left", action: "align-left", title: "Align Left" },
        { icon: "align-center", action: "align-center", title: "Align Center" },
        { icon: "align-right", action: "align-right", title: "Align Right" },
        { divider: true },
        { icon: "list", action: "list", title: "Bullet List" },
        { icon: "list-ordered", action: "list-ordered", title: "Numbered List" },
        { divider: true },
        { icon: "link", action: "link", title: "Insert Link" },
        { icon: "image", action: "image", title: "Insert Image" },
        { icon: "table", action: "table", title: "Insert Table" },
        { divider: true },
        {
          icon: "type",
          dropdown: true,
          items: [
            { text: "Heading 1", action: "h1" },
            { text: "Heading 2", action: "h2" },
            { text: "Heading 3", action: "h3" },
            { text: "Paragraph", action: "p" }
          ]
        }
      ]
    else
      []
    end
  end

  def build_rich_text_editor_class(additional_class)
    classes = [ "kt-rich-text-editor-content", "min-h-[200px] p-4 border border-border rounded-b focus:outline-none focus:ring-2 focus:ring-primary" ]
    classes << additional_class if additional_class
    classes.join(" ")
  end

  def build_markdown_editor_class(additional_class)
    classes = [ "kt-markdown-editor-content", "min-h-[200px] p-4 border border-border rounded focus:outline-none focus:ring-2 focus:ring-primary font-mono text-sm" ]
    classes << additional_class if additional_class
    classes.join(" ")
  end
end
