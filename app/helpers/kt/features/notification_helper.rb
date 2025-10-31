# app/helpers/kt/features/notification_helper.rb
module KT
  module Features
    module NotificationHelper
      include KT::UI::Base::BaseUIHelper
      include KT::Features::DrawerHelper

      # ===============================
      # 🔹 MAIN NOTIFICATION COMPONENTS
      # ===============================

      # ✅ SRP: Notification toggle button - using drawer helper
      def notification_toggle_button
        drawer_toggle_button(target: "#notifications_drawer", icon: "ki-notification-status")
      end

      # ✅ SRP: Complete notifications drawer
      def notifications_drawer(notifications:, tabs:)
        drawer_container(id: "notifications_drawer") do
          concat drawer_header(title: "Notifications")
          concat drawer_tabs(tabs)
          concat notification_tabs_content(notifications)
        end
      end

      # ===============================
      # 🔹 PRIVATE HELPERS
      # ===============================
      private

      # Tabs section
      def drawer_tabs(tabs)
        content_tag(:div, class: "kt-tabs kt-tabs-line justify-between px-5 mb-2", data: { "kt-tabs": true }, id: "notifications_tabs") do
          content_tag(:div, class: "flex items-center gap-5") do
            safe_join(tabs.map { |tab| notification_tab_button(**tab) })
          end
        end
      end

      # Individual tab button
      def notification_tab_button(title:, target:, active: false, indicator: false)
        classes = "kt-tab-toggle py-3 #{'active' if active} relative"
        content_tag(:button, class: classes, data: { "kt-tab-toggle": target }) do
          concat title
          concat(content_tag(:span, "", class: "rounded-full bg-green-500 size-[5px] absolute top-2 rtl:start-0 end-0 transform translate-y-1/2 translate-x-full")) if indicator
        end
      end

      # Content for each tab
      def notification_tabs_content(notifications)
        safe_join(
          notifications.map do |tab_id, items|
            content_tag(:div, id: tab_id, class: "grow flex flex-col #{tab_id == 'notifications_tab_all' ? '' : 'hidden'}") do
              concat drawer_body do
                content_tag(:div, class: "grow flex flex-col gap-5 pt-3 pb-4 divider-y divider-border") do
                  safe_join(items.map { |item| notification_item(item) })
                end
              end
              concat drawer_footer do
                notification_footer_actions([ "Archive all", "Mark all as read" ])
              end
            end
          end
        )
      end

      # Individual notification item
      def notification_item(item)
        content_tag(:div, class: "flex grow gap-2.5 px-5") do
          concat notification_avatar(item[:avatar], item[:status])
          concat notification_content(item)
        end
      end

      # Notification avatar - using base UI avatar
      def notification_avatar(image, status)
        ui_avatar(src: image, size: "size-8", status: status)
      end

      # Notification content
      def notification_content(item)
        content_tag(:div, class: "flex flex-col gap-3.5 grow") do
          concat notification_message(item[:message], item[:meta])
          concat notification_buttons(item[:actions]) if item[:actions]
          concat notification_badges(item[:badges]) if item[:badges]
        end
      end

      # Notification message and meta
      def notification_message(message, meta)
        content_tag(:div, class: "flex flex-col gap-1") do
          concat content_tag(:div, message.html_safe, class: "text-sm font-medium")
          concat content_tag(:span, meta, class: "flex items-center text-xs font-medium text-muted-foreground")
        end
      end

      # Notification badges
      def notification_badges(badges)
        content_tag(:div, class: "flex flex-wrap gap-2.5") do
          safe_join(badges.map { |b| ui_badge(text: b[:text], type: b[:type], size: :sm, outline: true) })
        end
      end

      # Notification action buttons
      def notification_buttons(actions)
        content_tag(:div, class: "flex flex-wrap gap-2.5") do
          safe_join(actions.map { |a| ui_button(text: a, variant: a.downcase == "accept" ? :solid : :outline, size: :sm) })
        end
      end

      # Footer actions
      def notification_footer_actions(actions)
        content_tag(:div, class: "grid grid-cols-2 gap-2.5") do
          safe_join(actions.map { |a| ui_button(text: a, variant: :outline, button_class: "justify-center") })
        end
      end
    end
  end
end
