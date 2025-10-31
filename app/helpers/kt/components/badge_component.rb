# app/helpers/kt/components/badge_component.rb
module KT::Components::BadgeComponent
  include KT::BaseUiHelper

  # ✅ SRP: Basic badge component
  def ui_badge(text:, variant: :default, size: :md, outline: false, **options)
    classes = build_badge_class(variant, size, outline)
    content_tag(:span, text, class: classes, **options)
  end

  # ✅ SRP: Status badge
  def ui_status_badge(status:, text: nil, **options)
    status_config = get_status_config(status)
    text ||= status_config[:text] || status.to_s.humanize
    ui_badge(text: text, variant: status_config[:variant], **options)
  end

  # ✅ SRP: Count badge
  def ui_count_badge(count:, max: 99, **options)
    display_count = count > max ? "#{max}+" : count.to_s
    ui_badge(text: display_count, variant: :primary, size: :sm, **options)
  end

  # ✅ SRP: Dot badge (small indicator)
  def ui_dot_badge(variant: :primary, size: :sm, **options)
    classes = build_dot_badge_class(variant, size)
    content_tag(:span, "", class: classes, **options)
  end

  private

  def build_badge_class(variant, size, outline)
    classes = ["kt-badge"]

    # Variant
    case variant
    when :primary then classes << "kt-badge-primary"
    when :secondary then classes << "kt-badge-secondary"
    when :success then classes << "kt-badge-success"
    when :danger then classes << "kt-badge-danger"
    when :warning then classes << "kt-badge-warning"
    when :info then classes << "kt-badge-info"
    when :light then classes << "kt-badge-light"
    when :dark then classes << "kt-badge-dark"
    else classes << "kt-badge-default"
    end

    # Size
    case size
    when :xs then classes << "kt-badge-xs"
    when :sm then classes << "kt-badge-sm"
    when :lg then classes << "kt-badge-lg"
    else classes << "kt-badge-md"
    end

    # Outline
    classes << "kt-badge-outline" if outline

    classes.join(" ")
  end

  def build_dot_badge_class(variant, size)
    classes = ["kt-dot-badge"]

    # Variant
    case variant
    when :primary then classes << "kt-dot-badge-primary"
    when :success then classes << "kt-dot-badge-success"
    when :danger then classes << "kt-dot-badge-danger"
    when :warning then classes << "kt-dot-badge-warning"
    else classes << "kt-dot-badge-default"
    end

    # Size
    case size
    when :xs then classes << "kt-dot-badge-xs"
    when :sm then classes << "kt-dot-badge-sm"
    when :lg then classes << "kt-dot-badge-lg"
    else classes << "kt-dot-badge-md"
    end

    classes.join(" ")
  end

  def get_status_config(status)
    case status.to_sym
    when :active, :enabled, :published
      { variant: :success, text: "Active" }
    when :inactive, :disabled, :draft
      { variant: :secondary, text: "Inactive" }
    when :pending, :waiting
      { variant: :warning, text: "Pending" }
    when :error, :failed, :rejected
      { variant: :danger, text: "Error" }
    when :completed, :done
      { variant: :success, text: "Completed" }
    else
      { variant: :default, text: status.to_s.humanize }
    end
  end
end