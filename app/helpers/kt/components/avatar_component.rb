# app/helpers/kt/components/avatar_component.rb
module KT::Components::AvatarComponent
  include KT::BaseUiHelper

  # ✅ SRP: Basic avatar component
  def ui_avatar(src: nil, alt: "", initials: nil, size: :md, variant: :circle, status: nil, **options)
    classes = build_avatar_classes(size, variant)
    content_tag(:div, class: classes, **options) do
      concat avatar_content(src, alt, initials)
      concat avatar_status(status) if status
    end
  end

  # ✅ SRP: Avatar group
  def ui_avatar_group(avatars: [], max: 5, size: :md, **options)
    visible_avatars = avatars.first(max)
    remaining_count = [avatars.size - max, 0].max

    content_tag(:div, class: "kt-avatar-group flex -space-x-2", **options) do
      safe_join(visible_avatars.each_with_index.map { |avatar, index| avatar_in_group(avatar, size, index) })
      concat avatar_overflow(remaining_count, size) if remaining_count > 0
    end
  end

  # ✅ SRP: Avatar with fallback
  def ui_avatar_with_fallback(user:, size: :md, **options)
    src = user.avatar_url || user.avatar
    initials = user_initials(user)
    ui_avatar(src: src, alt: user.name || user.email, initials: initials, size: size, **options)
  end

  private

  def avatar_content(src, alt, initials)
    if src.present?
      image_tag(src, alt: alt, class: "kt-avatar-image")
    elsif initials.present?
      content_tag(:span, initials, class: "kt-avatar-initials")
    else
      ui_icon(name: "user", size: :md, wrapper_class: "kt-avatar-placeholder")
    end
  end

  def avatar_status(status)
    status_class = build_status_class(status)
    content_tag(:div, class: "kt-avatar-status #{status_class}", "data-status": status)
  end

  def avatar_in_group(avatar_config, size, index)
    z_index = 10 - index # Higher index = lower z-index
    content_tag(:div, class: "relative z-#{z_index}") do
      ui_avatar(**avatar_config.merge(size: size))
    end
  end

  def avatar_overflow(count, size)
    content_tag(:div, class: "relative z-0") do
      ui_avatar(size: size, variant: :circle) do
        content_tag(:span, "+#{count}", class: "kt-avatar-overflow-text")
      end
    end
  end

  def user_initials(user)
    name = user.name || user.email
    return "" unless name.present?

    parts = name.split
    if parts.size > 1
      "#{parts.first[0]}#{parts.last[0]}".upcase
    else
      parts.first[0..1].upcase
    end
  end

  def build_avatar_classes(size, variant)
    classes = ["kt-avatar"]

    # Size
    case size
    when :xs then classes << "kt-avatar-xs"
    when :sm then classes << "kt-avatar-sm"
    when :md then classes << "kt-avatar-md"
    when :lg then classes << "kt-avatar-lg"
    when :xl then classes << "kt-avatar-xl"
    else classes << "kt-avatar-md"
    end

    # Variant
    case variant
    when :circle then classes << "kt-avatar-circle"
    when :rounded then classes << "kt-avatar-rounded"
    when :square then classes << "kt-avatar-square"
    end

    classes.join(" ")
  end

  def build_status_class(status)
    case status.to_sym
    when :online then "kt-avatar-status-online"
    when :offline then "kt-avatar-status-offline"
    when :away then "kt-avatar-status-away"
    when :busy then "kt-avatar-status-busy"
    else "kt-avatar-status-default"
    end
  end
end