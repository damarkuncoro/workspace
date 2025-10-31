# app/helpers/kt/components/notificationbell_component.rb
module KT::Components::NotificationbellComponent
  include KT::UI::Base::BaseUIHelper
  include KT::UI::Base::BaseDropdownHelper

  # ✅ SRP: Basic notification bell component
  def ui_notification_bell(count: 0, **options)
    bell_id = options[:id] || "notification-bell-#{SecureRandom.hex(4)}"
    classes = build_notification_bell_class(options.delete(:class))

    content_tag(:div, class: "kt-notification-bell-wrapper", **options) do
      concat notification_bell_button(bell_id, count)
      concat notification_bell_dropdown(bell_id)
    end
  end

  # ✅ SRP: Notification bell with custom trigger
  def ui_notification_bell_custom(trigger:, notifications: [], **options)
    bell_id = options[:id] || "notification-bell-custom-#{SecureRandom.hex(4)}"

    content_tag(:div, class: "kt-notification-bell-custom-wrapper", **options) do
      concat notification_custom_trigger(trigger, bell_id)
      concat notification_bell_dropdown(bell_id, notifications)
    end
  end

  # ✅ SRP: Notification item component
  def ui_notification_item(notification:, **options)
    content_tag(:div, class: "kt-notification-item flex gap-3 p-4 border-b border-border last:border-b-0 hover:bg-accent/50", **options) do
      concat notification_item_icon(notification)
      concat notification_item_content(notification)
      concat notification_item_actions(notification)
    end
  end

  private

  def notification_bell_button(bell_id, count)
    button_tag(class: "kt-notification-bell-button kt-btn kt-btn-ghost kt-btn-icon size-9 rounded-full hover:bg-primary/10 hover:[&_i]:text-primary relative",
               data: { "kt-dropdown-toggle": bell_id }) do
      concat ui_icon(name: "bell", size: :lg)
      concat notification_count_badge(count) if count > 0
    end
  end

  def notification_count_badge(count)
    content_tag(:span, class: "kt-notification-count absolute -top-1 -right-1 bg-red-500 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center font-medium") do
      count > 99 ? "99+" : count.to_s
    end
  end

  def notification_bell_dropdown(bell_id, notifications = [])
    dropdown_menu_container(menu_class: "kt-notification-dropdown w-80 max-h-96 overflow-y-auto") do
      concat notification_dropdown_header
      concat notification_list(notifications)
      concat notification_dropdown_footer
    end
  end

  def notification_dropdown_header
    dropdown_header_section(title: "Notifications", subtitle: "You have 3 unread messages")
  end

  def notification_list(notifications)
    if notifications.empty?
      notification_empty_state
    else
      dropdown_list_section(items: notifications.map { |n| ui_notification_item(notification: n) })
    end
  end

  def notification_empty_state
    content_tag(:div, class: "kt-notification-empty flex flex-col items-center justify-center py-12 text-center") do
      concat ui_icon(name: "bell-off", size: :xl, wrapper_class: "text-muted-foreground mb-4")
      concat content_tag(:h3, "No notifications", class: "text-sm font-medium text-muted-foreground mb-1")
      concat content_tag(:p, "You're all caught up!", class: "text-xs text-muted-foreground")
    end
  end

  def notification_dropdown_footer
    dropdown_footer_section(content: ui_link(text: "View all notifications", href: "/notifications", link_class: "kt-btn kt-btn-outline justify-center w-full"))
  end

  def notification_custom_trigger(trigger, bell_id)
    content_tag(:div, "data-kt-dropdown-toggle": bell_id) do
      trigger.respond_to?(:call) ? trigger.call : trigger
    end
  end

  def notification_item_icon(notification)
    icon_name = case notification[:type]
    when :message then "message-circle"
    when :warning then "alert-triangle"
    when :success then "check-circle"
    when :error then "x-circle"
    else "bell"
    end

    color_class = case notification[:type]
    when :warning then "text-yellow-500"
    when :success then "text-green-500"
    when :error then "text-red-500"
    else "text-blue-500"
    end

    content_tag(:div, class: "kt-notification-icon flex-shrink-0") do
      ui_icon(name: icon_name, size: :sm, wrapper_class: color_class)
    end
  end

  def notification_item_content(notification)
    content_tag(:div, class: "kt-notification-content flex-1 min-w-0") do
      concat content_tag(:p, notification[:message], class: "text-sm text-foreground truncate")
      concat content_tag(:p, notification[:time], class: "text-xs text-muted-foreground mt-1")
    end
  end

  def notification_item_actions(notification)
    actions = []
    actions << ui_button(text: "Mark as read", size: :xs, variant: :ghost) if notification[:unread]
    actions << ui_button(text: "Dismiss", size: :xs, variant: :ghost, icon: "x")

    content_tag(:div, class: "kt-notification-actions flex gap-1") do
      safe_join(actions)
    end
  end

  def build_notification_bell_class(additional_class)
    classes = [ "kt-notification-bell" ]
    classes << additional_class if additional_class
    classes.join(" ")
  end
end
