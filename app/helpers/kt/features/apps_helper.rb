# app/helpers/kt/features/apps_helper.rb
module KT
  module Features
    module AppsHelper
      include KT::UI::Base::BaseDropdownHelper
      include KT::UI::Base::BaseUIHelper

      # ===============================
      # 1️⃣ Dropdown Trigger
      # ===============================
      def apps_dropdown_button
        dropdown_trigger_button(icon: "ki-element-11")
      end

      # ===============================
      # 2️⃣ Dropdown Menu Wrapper
      # ===============================
      def apps_dropdown(apps:)
        dropdown_wrapper do
          concat apps_dropdown_button
          concat apps_dropdown_menu(apps)
        end
      end

      # ===============================
      # 🔹 PRIVATE HELPERS
      # ===============================
      private

      # Complete dropdown menu
      def apps_dropdown_menu(apps)
        dropdown_menu_container(menu_class: "kt-dropdown-menu p-0 w-screen max-w-[320px]") do
          concat apps_header_section
          concat apps_list_section(apps)
          concat apps_footer_section
        end
      end

      # Header section
      def apps_header_section
        dropdown_header_section(title: "Apps", subtitle: "Enabled")
      end

      # Apps list section
      def apps_list_section(apps)
        dropdown_list_section(items: apps.map { |app| app_item_component(app) })
      end

      # Individual app item
      def app_item_component(app)
        content_tag(:div, class: "flex items-center justify-between flex-wrap gap-2 px-5 py-3.5") do
          concat app_info_component(app)
          concat app_toggle_component(app)
        end
      end

      # App info component
      def app_info_component(app)
        content_tag(:div, class: "flex items-center flex-wrap gap-2") do
          concat app_logo_component(app[:logo])
          concat app_details_component(app)
        end
      end

      # App logo
      def app_logo_component(logo)
        content_tag(:div, class: "flex items-center justify-center shrink-0 rounded-full bg-accent/60 border border-border size-10") do
          image_tag(logo, alt: "", class: "size-6")
        end
      end

      # App details (name + description)
      def app_details_component(app)
        content_tag(:div, class: "flex flex-col") do
          concat(link_to(app[:name], app[:href] || "#", class: "text-sm font-semibold text-mono hover:text-primary"))
          concat(content_tag(:span, app[:description], class: "text-xs font-medium text-secondary-foreground"))
        end
      end

      # App toggle switch
      def app_toggle_component(app)
        content_tag(:div, class: "flex items-center gap-2 lg:gap-5") do
          ui_switch(name: app[:name].parameterize, checked: app[:enabled])
        end
      end

      # Footer section
      def apps_footer_section
        dropdown_footer_section(content: ui_link(text: "Go to Apps", href: "/demo1/account/integrations.html", link_class: "kt-btn kt-btn-outline justify-center"))
      end
    end
  end
end
