module KT
  module Chat
    module MenuHelper
      private

      # Chat menu component
      def chat_menu_component(menu)
        content_tag(:div, class: "kt-menu", data: { "kt-menu": true }) do
          content_tag(:div, class: "kt-menu-item", data: { "kt-menu-item-toggle": "dropdown", "kt-menu-item-trigger": "click|lg:hover" }) do
            concat chat_menu_button
            concat chat_menu_dropdown(menu)
          end
        end
      end

      # Menu button
      def chat_menu_button
        button_tag(class: "kt-menu-toggle kt-btn kt-btn-sm kt-btn-icon kt-btn-ghost") do
          content_tag(:i, "", class: "ki-filled ki-dots-vertical text-lg")
        end
      end

      # Menu dropdown
      def chat_menu_dropdown(menu)
        content_tag(:div, class: "kt-menu-dropdown kt-menu-default w-full max-w-[175px]", data: { "kt-menu-dismiss": true }) do
          safe_join(menu.map { |item| chat_menu_item_component(item) })
        end
      end

      # Menu item component
      def chat_menu_item_component(item)
        content_tag(:div, class: "kt-menu-item") do
          link_to(item[:href], class: "kt-menu-link") do
            concat(content_tag(:span, content_tag(:i, "", class: "ki-filled #{item[:icon]}"), class: "kt-menu-icon"))
            concat(content_tag(:span, item[:title], class: "kt-menu-title"))
          end
        end
      end
    end
  end
end
