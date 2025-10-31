# app/helpers/kt/components/button_component.rb
module KT::Components::ButtonComponent
  include KT::BaseUiHelper

  # ✅ SRP: Basic button component with variants
  def ui_button_component(text: nil, icon: nil, variant: :primary, size: :md, type: :button, disabled: false, loading: false, **options)
    classes = build_button_classes(variant: variant, size: size, disabled: disabled, loading: loading)
    options[:disabled] = true if disabled || loading

    button_tag(type: type, class: classes, **options) do
      concat loading_spinner if loading
      concat ui_icon(icon_class: "ki-filled #{icon}") if icon && !loading
      concat text if text
    end
  end

  # ✅ SRP: Link button variant
  def ui_link_button(text:, href:, variant: :primary, size: :md, **options)
    classes = build_button_classes(variant: variant, size: size)
    link_to(text, href, class: classes, **options)
  end

  # ✅ SRP: Icon-only button
  def ui_icon_button(icon:, variant: :ghost, size: :md, **options)
    ui_button_component(icon: icon, variant: variant, size: size, **options)
  end

  # ✅ SRP: Button group for multiple buttons
  def ui_button_group(buttons: [], variant: :primary, size: :md, orientation: :horizontal)
    group_class = orientation == :vertical ? "flex flex-col" : "flex"
    content_tag(:div, class: "#{group_class} kt-button-group") do
      safe_join(buttons.map do |btn_config|
        ui_button_component(**btn_config.merge(variant: variant, size: size))
      end)
    end
  end

  private

  def build_button_classes(variant:, size:, disabled: false, loading: false)
    classes = ["kt-btn"]

    # Variant classes
    case variant
    when :primary then classes << "kt-btn-primary"
    when :secondary then classes << "kt-btn-secondary"
    when :outline then classes << "kt-btn-outline"
    when :ghost then classes << "kt-btn-ghost"
    when :danger then classes << "kt-btn-danger"
    when :success then classes << "kt-btn-success"
    when :warning then classes << "kt-btn-warning"
    end

    # Size classes
    case size
    when :xs then classes << "kt-btn-xs"
    when :sm then classes << "kt-btn-sm"
    when :md then classes << "kt-btn-md"
    when :lg then classes << "kt-btn-lg"
    when :xl then classes << "kt-btn-xl"
    end

    # State classes
    classes << "kt-btn-disabled" if disabled
    classes << "kt-btn-loading" if loading

    classes.join(" ")
  end

  def loading_spinner
    ui_spinner(size: :sm, color: :current)
  end
end