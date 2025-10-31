module KT
  module Chat
    module FooterHelper
      private

      # Footer section
      def chat_footer_section(footer)
        content_tag(:div, class: "mb-2.5") do
          concat chat_join_request(footer[:join_request]) if footer[:join_request]
          concat chat_input_box(footer[:input])
        end
      end

      def chat_join_request(request)
        content_tag(:div, class: "flex grow gap-2 px-5 py-3.5 bg-accent/60 mb-2.5 border-y border-border", id: "join_request") do
          concat chat_avatar(request[:avatar])
          concat(
            content_tag(:div, class: "flex items-center justify-between gap-3 grow") do
              concat(content_tag(:div, class: "flex flex-col") do
                concat(content_tag(:div, class: "text-sm mb-px") do
                  concat(link_to(request[:name], "#", class: "hover:text-primary font-semibold text-mono"))
                  concat(content_tag(:span, " wants to join chat", class: "text-secondary-foreground"))
                end)
                concat(content_tag(:span, "#{request[:time]} · #{request[:team]}", class: "flex items-center text-xs font-medium text-muted-foreground"))
              end)
              concat(content_tag(:div, class: "flex gap-2.5") do
                concat(button_tag("Decline", class: "kt-btn kt-btn-sm kt-btn-outline", data: { "kt-dismiss": "#join_request" }))
                concat(button_tag("Accept", class: "kt-btn kt-btn-sm kt-btn-mono"))
              end)
            end
          )
        end
      end

      def chat_input_box(input)
        content_tag(:div, class: "relative grow mx-5") do
          concat(image_tag(input[:avatar], class: "rounded-full size-[30px] absolute start-0 top-2/4 -translate-y-2/4 ms-2.5", alt: ""))
          concat(text_field_tag(:message, nil, placeholder: "Write a message...", class: "kt-input h-auto py-4 ps-12 bg-transparent"))
          concat(content_tag(:div, class: "flex items-center gap-2.5 absolute end-3 top-1/2 -translate-y-1/2") do
            concat(button_tag(class: "kt-btn kt-btn-sm kt-btn-icon kt-btn-ghost") do
              content_tag(:i, "", class: "ki-filled ki-exit-up")
            end)
            concat(link_to("Send", "#", class: "kt-btn kt-btn-mono kt-btn-sm"))
          end)
        end
      end
    end
  end
end
