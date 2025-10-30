module KT::Card::BodyHelper
  # ✅ SRP: Body card dengan padding options
  def card_body(body_class: "kt-card-content", padding: "p-5 lg:p-7.5", &block)
    content_tag(:div, class: "#{body_class} #{padding}") do
      capture(&block)
    end
  end

  # ✅ SRP: Body dengan scrollable content
  def card_body_scrollable(body_class: "kt-card-content", max_height: "max-h-96", &block)
    content_tag(:div, class: "#{body_class} overflow-y-auto", style: "max-height: #{max_height}") do
      capture(&block)
    end
  end

  # ✅ SRP: Body dengan custom styling
  def card_body_custom(body_class: "kt-card-content", custom_class: nil, &block)
    classes = [body_class]
    classes << custom_class if custom_class
    content_tag(:div, class: classes.join(" ")) do
      capture(&block)
    end
  end

  # ✅ SRP: Body dengan flex layout
  def card_body_flex(direction: "flex-col", justify: nil, items: nil, gap: "gap-5", body_class: "kt-card-content", padding: nil, &block)
    classes = [body_class, "flex", direction]
    classes << "justify-#{justify}" if justify
    classes << "items-#{items}" if items
    classes << gap
    classes << padding if padding
    content_tag(:div, class: classes.join(" ")) do
      capture(&block)
    end
  end
end