module KT::ButtonHelper
  include KT::BaseUiHelper

  # ✅ SRP: Single responsibility - button creation with consistent styling
  def kt_button(text: nil, icon: nil, variant: :solid, type: :primary, size: :default, button_class: "", **options)
    ui_button(text: text, icon: icon, type: type, size: size, variant: variant, button_class: "kt-btn #{button_class}", **options)
  end

  # ✅ SRP: Icon-only button variant
  def kt_icon_button(icon:, variant: :ghost, size: :default, button_class: "", **options)
    kt_button(icon: icon, variant: variant, size: size, button_class: "kt-btn-icon #{button_class}", **options)
  end

  # ✅ SRP: Ghost button variant (common pattern)
  def kt_ghost_button(text: nil, icon: nil, button_class: "", **options)
    kt_button(text: text, icon: icon, variant: :ghost, button_class: button_class, **options)
  end

  # ✅ SRP: Outline button variant
  def kt_outline_button(text: nil, icon: nil, button_class: "", **options)
    kt_button(text: text, icon: icon, variant: :outline, button_class: button_class, **options)
  end
end
