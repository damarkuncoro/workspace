# app/helpers/kt/components/card_component.rb
module KT::Components::CardComponent
  include KT::BaseUiHelper

  # ✅ SRP: Basic card component
  def ui_card(variant: :default, padding: :md, shadow: :sm, rounded: true, **options, &block)
    classes = build_card_classes(variant: variant, padding: padding, shadow: shadow, rounded: rounded)
    content_tag(:div, class: classes, **options, &block)
  end

  # ✅ SRP: Card with header
  def ui_card_with_header(header:, variant: :default, padding: :md, shadow: :sm, **options, &block)
    ui_card(variant: variant, padding: :none, shadow: shadow, **options) do
      concat ui_card_header(content: header)
      concat content_tag(:div, class: "p-#{padding == :md ? 4 : padding == :lg ? 6 : 4}", &block)
    end
  end

  # ✅ SRP: Card with footer
  def ui_card_with_footer(footer:, variant: :default, padding: :md, shadow: :sm, **options, &block)
    ui_card(variant: variant, padding: :none, shadow: shadow, **options) do
      concat content_tag(:div, class: "p-#{padding == :md ? 4 : padding == :lg ? 6 : 4}", &block)
      concat ui_card_footer(content: footer)
    end
  end

  # ✅ SRP: Full card with header and footer
  def ui_card_full(header:, footer:, variant: :default, padding: :md, shadow: :sm, **options, &block)
    ui_card(variant: variant, padding: :none, shadow: shadow, **options) do
      concat ui_card_header(content: header)
      concat content_tag(:div, class: "p-#{padding == :md ? 4 : padding == :lg ? 6 : 4}", &block)
      concat ui_card_footer(content: footer)
    end
  end

  # ✅ SRP: Card header component
  def ui_card_header(content:, actions: nil, **options)
    classes = options.delete(:class) || "kt-card-header flex items-center justify-between p-4 border-b border-border"
    content_tag(:div, class: classes, **options) do
      concat content_tag(:div, content, class: "kt-card-title")
      concat content_tag(:div, actions, class: "kt-card-actions") if actions
    end
  end

  # ✅ SRP: Card footer component
  def ui_card_footer(content:, justify: :end, **options)
    classes = options.delete(:class) || "kt-card-footer flex items-center #{justify == :end ? 'justify-end' : justify == :center ? 'justify-center' : 'justify-start'} p-4 border-t border-border"
    content_tag(:div, class: classes, **options) do
      content
    end
  end

  # ✅ SRP: Card body component
  def ui_card_body(padding: :md, **options, &block)
    classes = options.delete(:class) || "kt-card-body p-#{padding == :md ? 4 : padding == :lg ? 6 : 4}"
    content_tag(:div, class: classes, **options, &block)
  end

  # ✅ SRP: Interactive card
  def ui_card_interactive(hover: true, **options, &block)
    classes = build_card_classes(variant: :default, padding: :md, shadow: :sm, rounded: true)
    classes += " #{hover ? 'hover:shadow-lg transition-shadow cursor-pointer' : ''}"
    content_tag(:div, class: classes, **options, &block)
  end

  private

  def build_card_classes(variant:, padding:, shadow:, rounded:)
    classes = ["kt-card"]

    # Variant classes
    case variant
    when :default then classes << "bg-background border border-border"
    when :elevated then classes << "bg-background border border-border shadow-lg"
    when :filled then classes << "bg-muted/50 border border-border"
    when :outlined then classes << "border-2 border-primary bg-transparent"
    when :ghost then classes << "border border-transparent bg-transparent"
    end

    # Shadow
    shadow_class = case shadow
                   when :none then ""
                   when :sm then "shadow-sm"
                   when :md then "shadow-md"
                   when :lg then "shadow-lg"
                   when :xl then "shadow-xl"
                   else "shadow-sm"
                   end
    classes << shadow_class if shadow_class.present?

    # Rounded
    classes << "rounded-lg" if rounded

    # Padding (only for basic card)
    if padding != :none
      padding_class = case padding
                      when :sm then "p-3"
                      when :md then "p-4"
                      when :lg then "p-6"
                      when :xl then "p-8"
                      else "p-4"
                      end
      classes << padding_class
    end

    classes.join(" ")
  end
end