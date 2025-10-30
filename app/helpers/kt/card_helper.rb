module KT::CardHelper
  include KT::Card::CardHelper
  include KT::Card::HeaderHelper
  include KT::Card::BodyHelper
  include KT::Card::FooterHelper

  # ✅ SRP: Builder untuk berbagai jenis card
  def card_builder(type: :standard, title: nil, actions: nil, &block)
    case type
    when :standard
      full_card(title: title, header_actions: actions, &block)
    when :bordered
      styled_card(variant: :bordered, title: title, &block)
    when :elevated
      styled_card(variant: :elevated, title: title, &block)
    when :flat
      styled_card(variant: :flat, title: title, &block)
    else
      card(&block)
    end
  end

  # ✅ SRP: Card dengan responsive layout
  def responsive_card(breakpoint: "lg", title: nil, &block)
    card_class = "kt-card #{breakpoint}:border #{breakpoint}:shadow-lg"
    full_card(title: title, card_class: card_class, &block)
  end

  # ✅ SRP: Card dengan theme variants
  def themed_card(theme: :light, title: nil, &block)
    card_class = case theme
                 when :dark then "kt-card bg-gray-900 text-white"
                 when :light then "kt-card bg-white"
                 when :muted then "kt-card bg-muted/50"
                 else "kt-card"
                 end
    full_card(title: title, card_class: card_class, &block)
  end
end