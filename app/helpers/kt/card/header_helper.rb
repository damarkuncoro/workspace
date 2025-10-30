module KT::Card::HeaderHelper
  # ✅ SRP: Header card dengan title dan actions
  def card_header(title: nil, subtitle: nil, actions: nil, header_class: "kt-card-header", title_class: "kt-card-title", subtitle_class: "kt-card-subtitle")
    content_tag(:div, class: header_class) do
      concat(content_tag(:div, class: "flex items-center justify-between gap-2") do
        concat(content_tag(:div) do
          if title
            concat(content_tag(:h3, title, class: title_class))
          end
          if subtitle
            concat(content_tag(:p, subtitle, class: subtitle_class))
          end
        end)
        if actions
          concat(content_tag(:div, class: "flex items-center gap-2") do
            actions.respond_to?(:each) ? actions.each { |action| concat(action) } : concat(actions)
          end)
        end
      end)
    end
  end

  # ✅ SRP: Header dengan custom content
  def card_header_custom(header_class: "kt-card-header", &block)
    content_tag(:div, class: header_class) do
      capture(&block)
    end
  end

  # ✅ SRP: Header dengan gap dan alignment
  def card_header_flex(justify: "between", items: "center", gap: "gap-2", header_class: "kt-card-header", &block)
    content_tag(:div, class: "#{header_class} flex justify-#{justify} items-#{items} #{gap}") do
      capture(&block)
    end
  end
end
