module KT
  module Chat
    module MessagesHelper
      private

      # Messages section
      def chat_messages_section(messages)
        content_tag(:div, class: "kt-scrollable-y-auto grow", data: { "kt-scrollable": true, "kt-scrollable-dependencies": "#header", "kt-scrollable-max-height": "auto", "kt-scrollable-offset": "230px" }) do
          content_tag(:div, class: "flex flex-col gap-5 py-5") do
            safe_join(messages.map { |msg| chat_message_component(msg) })
          end
        end
      end

      # Message component
      def chat_message_component(msg)
        side_class = msg[:from_me] ? "justify-end" : ""
        content_tag(:div, class: "flex items-end #{side_class} gap-3.5 px-5") do
          if msg[:from_me]
            concat chat_bubble(msg, mine: true)
            concat chat_avatar(msg[:avatar])
          else
            concat image_tag(msg[:avatar], class: "rounded-full size-9")
            concat chat_bubble(msg)
          end
        end
      end

      def chat_bubble(msg, mine: false)
        wrapper_class = mine ? "flex flex-col gap-1.5 text-right" : "flex flex-col gap-1.5"
        bubble_class = "kt-card shadow-none flex flex-col #{mine ? 'bg-primary text-primary-foreground rounded-be-none' : 'bg-accent/60 text-foreground rounded-bs-none'} gap-2.5 p-3 text-2sm"

        content_tag(:div, class: wrapper_class) do
          concat(content_tag(:div, msg[:text], class: bubble_class))
          concat(content_tag(:span, msg[:time], class: "text-xs font-medium text-muted-foreground"))
        end
      end

      def chat_avatar(src)
        content_tag(:div, class: "relative shrink-0") do
          content_tag(:div, class: "kt-avatar size-9") do
            concat(content_tag(:div, image_tag(src, alt: "avatar"), class: "kt-avatar-image"))
            concat(content_tag(:div, class: "kt-avatar-indicator -end-2 -bottom-2") do
              content_tag(:div, "", class: "kt-avatar-status kt-avatar-status-online size-2.5")
            end)
          end
        end
      end
    end
  end
end
