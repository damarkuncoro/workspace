# app/helpers/kt/components/tooltip_component.rb
module KT::Components::TooltipComponent
  include KT::UI::Base::BaseUIHelper

  # ✅ SRP: Basic tooltip component
  def ui_tooltip(content:, placement: :top, trigger: :hover, **options, &block)
    wrapper_attrs = build_tooltip_wrapper_attrs(placement, trigger)
    tooltip_attrs = build_tooltip_attrs(content, placement)

    content_tag(:div, class: "kt-tooltip-wrapper", **wrapper_attrs.merge(options)) do
      concat content_tag(:div, "", class: "kt-tooltip-trigger", &block)
      concat content_tag(:div, content, class: "kt-tooltip", **tooltip_attrs)
    end
  end

  # ✅ SRP: Icon with tooltip
  def ui_icon_with_tooltip(icon:, tooltip:, placement: :top, **options)
    ui_tooltip(content: tooltip, placement: placement, **options) do
      ui_icon(name: icon, **options.except(:placement))
    end
  end

  # ✅ SRP: Button with tooltip
  def ui_button_with_tooltip(text: nil, icon: nil, tooltip:, placement: :top, **options)
    ui_tooltip(content: tooltip, placement: placement) do
      ui_button(text: text, icon: icon, **options.except(:tooltip, :placement))
    end
  end

  # ✅ SRP: Text with tooltip
  def ui_text_with_tooltip(text:, tooltip:, placement: :top, **options)
    ui_tooltip(content: tooltip, placement: placement, **options) do
      content_tag(:span, text, class: "kt-tooltip-text")
    end
  end

  private

  def build_tooltip_wrapper_attrs(placement, trigger)
    {
      "data-kt-tooltip": true,
      "data-placement": placement,
      "data-trigger": trigger
    }
  end

  def build_tooltip_attrs(content, placement)
    classes = [ "kt-tooltip-content" ]

    # Placement classes
    case placement
    when :top then classes << "kt-tooltip-top"
    when :bottom then classes << "kt-tooltip-bottom"
    when :left then classes << "kt-tooltip-left"
    when :right then classes << "kt-tooltip-right"
    end

    { class: classes.join(" ") }
  end
end
