# app/helpers/kt/components/chatbubble_component.rb
module KT::Components::ChatbubbleComponent
  include KT::BaseUiHelper

  # ✅ SRP: Basic chat bubble component
  def ui_chat_bubble(message:, sender: :user, avatar: nil, time: nil, **options)
    bubble_id = options[:id] || "bubble-#{SecureRandom.hex(4)}"
    classes = build_chat_bubble_class(sender, options.delete(:class))

    content_tag(:div, class: classes, **options) do
      concat chat_bubble_avatar(avatar, sender) if avatar
      concat chat_bubble_content(message, sender, time)
    end
  end

  # ✅ SRP: Chat bubble with actions
  def ui_chat_bubble_with_actions(message:, actions: [], **options)
    content_tag(:div, class: "kt-chat-bubble-with-actions") do
      concat ui_chat_bubble(message: message, **options.except(:actions))
      concat chat_bubble_actions(actions)
    end
  end

  # ✅ SRP: Chat bubble group (multiple messages from same sender)
  def ui_chat_bubble_group(messages: [], sender: :user, avatar: nil, **options)
    return "" if messages.empty?

    content_tag(:div, class: "kt-chat-bubble-group", **options) do
      concat chat_group_avatar(avatar, sender) if avatar
      concat content_tag(:div, class: "kt-chat-group-messages") do
        safe_join(messages.map.with_index do |message, index|
          ui_chat_bubble(message: message, sender: sender, avatar: nil, time: index == messages.size - 1 ? message[:time] : nil)
        end)
      end
    end
  end

  # ✅ SRP: Typing indicator
  def ui_typing_indicator(sender: :user, avatar: nil, **options)
    classes = build_typing_indicator_class(sender)

    content_tag(:div, class: classes, **options) do
      concat chat_bubble_avatar(avatar, sender) if avatar
      concat content_tag(:div, class: "kt-typing-indicator") do
        content_tag(:div, class: "kt-typing-dots flex gap-1") do
          3.times do
            concat content_tag(:div, "", class: "kt-typing-dot w-2 h-2 bg-current rounded-full animate-pulse")
          end
        end
      end
    end
  end

  private

  def chat_bubble_avatar(avatar, sender)
    avatar_classes = ["kt-chat-avatar", sender == :user ? "order-2 ml-3" : "order-1 mr-3"]
    content_tag(:div, class: avatar_classes.join(" ")) do
      ui_avatar(src: avatar, size: :sm)
    end
  end

  def chat_bubble_content(message, sender, time)
    content_classes = ["kt-chat-content", sender == :user ? "order-1" : "order-2"]

    content_tag(:div, class: content_classes.join(" ")) do
      concat chat_bubble_message(message, sender)
      concat chat_bubble_time(time) if time
    end
  end

  def chat_bubble_message(message, sender)
    bubble_classes = ["kt-chat-bubble-message", "px-4 py-2 rounded-2xl max-w-xs break-words"]
    bubble_classes << (sender == :user ? "kt-chat-bubble-user bg-primary text-primary-foreground ml-auto" : "kt-chat-bubble-other bg-muted")

    content_tag(:div, class: bubble_classes.join(" ")) do
      if message.is_a?(Hash) && message[:type] == :image
        image_tag(message[:src], alt: message[:alt] || "", class: "kt-chat-image max-w-full rounded")
      else
        message.respond_to?(:html_safe) ? message.html_safe : message
      end
    end
  end

  def chat_bubble_time(time)
    content_tag(:div, class: "kt-chat-time text-xs text-muted-foreground mt-1 #{time_sender_class(@sender)}") do
      time
    end
  end

  def chat_bubble_actions(actions)
    content_tag(:div, class: "kt-chat-actions flex gap-1 mt-2 ml-4") do
      safe_join(actions.map { |action| action.respond_to?(:call) ? action.call : action })
    end
  end

  def chat_group_avatar(avatar, sender)
    content_tag(:div, class: "kt-chat-group-avatar #{sender == :user ? 'order-2 ml-3' : 'order-1 mr-3'}") do
      ui_avatar(src: avatar, size: :sm)
    end
  end

  def time_sender_class(sender)
    sender == :user ? "text-right" : "text-left"
  end

  def build_chat_bubble_class(sender, additional_class)
    classes = ["kt-chat-bubble", "flex items-end gap-3 mb-4"]
    classes << (sender == :user ? "justify-end" : "justify-start")
    classes << additional_class if additional_class
    classes.join(" ")
  end

  def build_typing_indicator_class(sender)
    classes = ["kt-typing-indicator-wrapper", "flex items-end gap-3 mb-4"]
    classes << (sender == :user ? "justify-end" : "justify-start")
    classes.join(" ")
  end
end