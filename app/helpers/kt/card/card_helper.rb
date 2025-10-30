module KT::Card::CardHelper
  # ✅ SRP: Base card wrapper
  def card(card_class: "kt-card", shadow: true, &block)
    classes = [card_class]
    classes << "shadow-sm" if shadow
    content_tag(:div, class: classes.join(" ")) do
      capture(&block)
    end
  end

  # ✅ SRP: Card dengan header, body, footer
  def full_card(title: nil, header_actions: nil, footer_actions: nil, card_class: "kt-card", &block)
    card(card_class: card_class) do
      concat(card_header(title: title, actions: header_actions)) if title || header_actions
      concat(card_body(&block))
      concat(card_footer(actions: footer_actions)) if footer_actions
    end
  end

  # ✅ SRP: Card dengan variant styling
  def styled_card(variant: :default, title: nil, &block)
    card_class = case variant
                 when :bordered then "kt-card border border-border"
                 when :elevated then "kt-card shadow-lg"
                 when :flat then "kt-card shadow-none"
                 else "kt-card"
                 end

    full_card(title: title, card_class: card_class, &block)
  end

  # ✅ SRP: Card dengan custom attributes
  def custom_card(attributes: {}, &block)
    content_tag(:div, { class: "kt-card" }.merge(attributes)) do
      capture(&block)
    end
  end
end