module KT
  module UI
    module CardHelper
      include KT::Card::CardHelper
      include KT::Card::HeaderHelper
      include KT::Card::BodyHelper
      include KT::Card::FooterHelper

      # ===============================
      # 🔹 CARD COMPONENTS
      # ===============================

      # ✅ SRP: Builder untuk berbagai jenis card - consolidated logic
      def card_builder(type: :standard, title: nil, actions: nil, theme: nil, breakpoint: nil, &block)
        # Determine card class based on type, theme, and breakpoint
        card_class = build_card_class(type: type, theme: theme, breakpoint: breakpoint)

        case type
        when :standard, :bordered, :elevated, :flat
          full_card(title: title, header_actions: actions, card_class: card_class, &block)
        else
          card(card_class: card_class, &block)
        end
      end

      # ✅ SRP: Responsive card - now uses card_builder
      def responsive_card(breakpoint: "lg", title: nil, &block)
        card_builder(type: :standard, title: title, breakpoint: breakpoint, &block)
      end

      # ✅ SRP: Themed card - now uses card_builder
      def themed_card(theme: :light, title: nil, &block)
        card_builder(type: :standard, title: title, theme: theme, &block)
      end

      private

      # ✅ SRP: Centralized card class building logic
      def build_card_class(type: :standard, theme: nil, breakpoint: nil)
        classes = [ "kt-card" ]

        # Type-based styling
        case type
        when :bordered then classes << "border border-border"
        when :elevated then classes << "shadow-lg"
        when :flat then classes << "shadow-none"
        end

        # Theme-based styling
        case theme
        when :dark then classes << "bg-gray-900 text-white"
        when :light then classes << "bg-white"
        when :muted then classes << "bg-muted/50"
        end

        # Breakpoint-based styling
        if breakpoint
          classes << "#{breakpoint}:border #{breakpoint}:shadow-lg"
        end

        classes.join(" ")
      end
    end
  end
end
