module KT::Card::FooterHelper
  # ✅ SRP: Footer card dengan actions
  def card_footer(actions: nil, justify: "center", footer_class: "kt-card-footer", &block)
    content_tag(:div, class: "#{footer_class} justify-#{justify}") do
      if block_given?
        capture(&block)
      elsif actions
        content_tag(:div, class: "flex items-center gap-2") do
          actions.respond_to?(:each) ? actions.each { |action| concat(action) } : concat(actions)
        end
      end
    end
  end

  # ✅ SRP: Footer dengan link
  def card_footer_link(text, href, link_class: "kt-link kt-link-underlined kt-link-dashed", footer_class: "kt-card-footer")
    card_footer(footer_class: footer_class) do
      link_to(text, href, class: link_class)
    end
  end

  # ✅ SRP: Footer dengan multiple actions
  def card_footer_actions(actions: [], footer_class: "kt-card-footer")
    card_footer(footer_class: footer_class) do
      content_tag(:div, class: "flex items-center gap-2.5") do
        actions.each { |action| concat(action) }
      end
    end
  end

  # ✅ SRP: Footer dengan custom content
  def card_footer_custom(footer_class: "kt-card-footer", &block)
    content_tag(:div, class: footer_class) do
      capture(&block)
    end
  end
end
