# app/helpers/kt/components/icon_component.rb
module KT::Components::IconComponent
  include KT::UI::Base::BaseUIHelper

  # ✅ SRP: Basic icon component
  def ui_icon(name:, size: :md, color: :default, variant: :filled, **options)
    icon_class = build_icon_class(name: name, size: size, color: color, variant: variant)
    wrapper_class = options.delete(:wrapper_class) || ""

    if wrapper_class.present?
      content_tag(:span, class: wrapper_class) do
        content_tag(:i, "", class: icon_class)
      end
    else
      content_tag(:i, "", class: icon_class)
    end
  end

  # ✅ SRP: Icon button component
  def ui_icon_button(name:, size: :md, variant: :ghost, **options)
    ui_button(icon: name, variant: variant, size: size, button_class: "kt-btn-icon", **options)
  end

  # ✅ SRP: Icon with text component
  def ui_icon_with_text(icon:, text:, size: :md, color: :default, variant: :filled, direction: :horizontal)
    wrapper_class = direction == :vertical ? "flex flex-col items-center gap-2" : "flex items-center gap-2"

    content_tag(:div, class: wrapper_class) do
      concat ui_icon(name: icon, size: size, color: color, variant: variant)
      concat content_tag(:span, text, class: "text-sm")
    end
  end

  # ✅ SRP: Status icon based on state
  def ui_status_icon(status:, size: :md)
    icon_name = case status.to_sym
                when :success, :completed then "ki-check-circle"
                when :error, :failed then "ki-cross-circle"
                when :warning then "ki-information-2"
                when :info then "ki-information-3"
                when :loading then "ki-loading"
                else "ki-dot"
                end

    color = case status.to_sym
            when :success, :completed then :success
            when :error, :failed then :danger
            when :warning then :warning
            when :info then :info
            else :default
            end

    ui_icon(name: icon_name, size: size, color: color)
  end

  # ✅ SRP: Social media icons
  def ui_social_icon(platform:, size: :md, **options)
    icon_name = case platform.to_sym
                when :facebook then "ki-facebook"
                when :twitter, :x then "ki-twitter"
                when :instagram then "ki-instagram"
                when :linkedin then "ki-linkedin"
                when :youtube then "ki-youtube"
                when :github then "ki-github"
                when :discord then "ki-discord"
                else "ki-share"
                end

    ui_icon_button(name: icon_name, size: size, **options)
  end

  # ✅ SRP: Icon stack for layered icons
  def ui_icon_stack(icons:, size: :md)
    content_tag(:div, class: "relative") do
      safe_join(icons.each_with_index.map do |icon_config, index|
        z_index = icons.length - index
        position_class = index == 0 ? "" : "absolute -top-1 -right-1"
        ui_icon(**icon_config.merge(size: size), wrapper_class: "#{position_class} z-#{z_index}")
      end)
    end
  end

  private

  def build_icon_class(name:, size:, color:, variant:)
    classes = []

    # Base icon class
    classes << "ki-#{variant}" if variant != :filled
    classes << "ki-filled" if variant == :filled

    # Icon name
    classes << "ki-#{name}"

    # Size classes
    size_class = case size
                 when :xs then "text-xs"
                 when :sm then "text-sm"
                 when :md then "text-base"
                 when :lg then "text-lg"
                 when :xl then "text-xl"
                 when :2xl then "text-2xl"
                 else "text-base"
                 end
    classes << size_class

    # Color classes
    color_class = case color
                  when :primary then "text-primary"
                  when :secondary then "text-secondary"
                  when :success then "text-green-500"
                  when :danger, :error then "text-red-500"
                  when :warning then "text-yellow-500"
                  when :info then "text-blue-500"
                  when :muted then "text-muted-foreground"
                  else ""
                  end
    classes << color_class if color_class.present?

    classes.join(" ")
  end
end