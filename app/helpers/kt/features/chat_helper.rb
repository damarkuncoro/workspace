# app/helpers/kt/features/chat_helper.rb
module KT
  module Features
    module ChatHelper
      include KT::Chat::HeaderHelper
      include KT::Chat::MessagesHelper
      include KT::Chat::FooterHelper
      include KT::Chat::MenuHelper
      include KT::UI::Base::BaseUIHelper

      # ===============================
      # 🔹 MAIN INTERFACE
      # ===============================

      # ✅ Complete chat drawer component
      def chat_drawer(chat:)
        drawer_container do
          concat chat_header_section(chat[:header])
          concat chat_messages_section(chat[:messages])
          concat chat_footer_section(chat[:footer])
        end
      end

      # ✅ Chat toggle button - using base UI helper
      def chat_toggle_button(target: "#chat_drawer")
        ui_button(icon: "ki-messages", variant: :ghost, size: :default,
                  button_class: "kt-btn-icon size-9 rounded-full hover:bg-primary/10 hover:[&_i]:text-primary",
                  data: { "kt-drawer-toggle": target })
      end

      # ===============================
      # 🔹 PRIVATE HELPERS
      # ===============================

      private

      # Drawer container wrapper
      def drawer_container(&block)
        content_tag(:div,
                    id: "chat_drawer",
                    class: "hidden kt-drawer kt-drawer-end card flex-col max-w-[90%] w-[450px] top-5 bottom-5 end-5 rounded-xl border border-border",
                    data: { "kt-drawer": true, "kt-drawer-container": "body" }, &block)
      end
    end
  end
end
