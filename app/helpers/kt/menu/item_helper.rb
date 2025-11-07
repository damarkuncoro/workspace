# app/helpers/kt/menu/item_helper.rb
#
# KT Menu Item Helper - Provides helpers for creating menu items with accordion and dropdown functionality
#
# Usage Examples:
#
# 1. Accordion Menu Item:
#    <%= kt_menu_item_accordion(title: "Dashboards", icon: "ki-element-11", active: true) do %>
#      <%= kt_menu_item_link(title: "Light Sidebar", href: "/demo1.html") %>
#      <%= kt_menu_item_link(title: "Dark Sidebar", href: "/demo1/dark.html") %>
#    <% end %>
#
# 2. Menu Link:
#    <%= kt_menu_item_link(title: "Dashboard", href: "/dashboard", active: true) %>
#
# 3. Menu Heading:
#    <%= kt_menu_item_heading(title: "User Management", uppercase: true) %>
#
# 4. Legacy Support (still works):
#    <%= kt_menu_item("Dashboards", icon: "ki-element-11") do %>
#      <%= kt_menu_link("Light Sidebar", href: "/demo1.html") %>
#    <% end %>
#
module KT
  module Menu
    module ItemHelper
      # =====================
      # Menu Item helper - Redesigned with **args, &block
      # =====================

      # Accordion menu item
      def kt_menu_item_accordion(**args, &block)
        # Default options
        options = {
          title: nil,
          icon: nil,
          active: false,
          show: false,
          class_name: "",
          trigger: "click",
          tag: :div
        }.merge(args)

        # Build item classes
        classes = ["kt-menu-item", "kt-menu-item-accordion"]
        classes << "active" if options[:active]
        classes << "show" if options[:show]
        classes << options[:class_name] if options[:class_name].present?

        final_class = classes.compact.join(" ")

        content_tag(options[:tag], class: final_class, data: { "kt-menu-item-toggle": "accordion", "kt-menu-item-trigger": options[:trigger] }) do
          # Header link
          concat(
            content_tag(:div,
              class: "kt-menu-link flex items-center grow cursor-pointer border border-transparent gap-[10px] ps-[10px] pe-[10px] py-[6px]",
              tabindex: "0"
            ) do
              # Icon
              if options[:icon]
                concat(content_tag(:span, class: "kt-menu-icon items-start text-muted-foreground w-[20px]") do
                  content_tag(:i, "", class: "ki-filled #{options[:icon]} text-lg")
                end)
              end

              # Title
              if options[:title]
                concat(content_tag(:span, options[:title],
                  class: "kt-menu-title text-sm font-medium text-foreground kt-menu-item-active:text-primary kt-menu-link-hover:!text-primary"
                ))
              end

              # Arrow
              concat(content_tag(:span, class: "kt-menu-arrow text-muted-foreground w-[20px] shrink-0 justify-end ms-1 me-[-10px]") do
                concat(content_tag(:span, class: "inline-flex kt-menu-item-show:hidden") do
                  content_tag(:i, "", class: "ki-filled ki-plus text-[11px]")
                end)
                concat(content_tag(:span, class: "hidden kt-menu-item-show:inline-flex") do
                  content_tag(:i, "", class: "ki-filled ki-minus text-[11px]")
                end)
              end)
            end
          )

          # Accordion content
          concat(content_tag(:div,
            class: "kt-menu-accordion gap-1 ps-[10px] relative before:absolute before:start-[20px] before:top-0 before:bottom-0 before:border-s before:border-border",
            style: "height: 0px;"
          ) do
            if block_given?
              capture(&block)
            else
              ""
            end
          end)
        end
      end

      # Menu link for accordion items
      def kt_menu_item_link(**args)
        # Default options
        options = {
          title: nil,
          href: "#",
          active: false,
          class_name: "",
          tag: :div
        }.merge(args)

        # Build item classes
        classes = ["kt-menu-item"]
        classes << "active" if options[:active]
        classes << options[:class_name] if options[:class_name].present?

        final_class = classes.compact.join(" ")

        content_tag(options[:tag], class: final_class) do
          link_to options[:href],
            class: "kt-menu-link border border-transparent items-center grow kt-menu-item-active:bg-accent/60 dark:menu-item-active:border-border kt-menu-item-active:rounded-lg hover:bg-accent/60 hover:rounded-lg gap-[14px] ps-[10px] pe-[10px] py-[8px]",
            tabindex: "0" do
              concat(content_tag(:span, "", class: "kt-menu-bullet flex w-[6px] -start-[3px] rtl:start-0 relative before:absolute before:top-0 before:size-[6px] before:rounded-full rtl:before:translate-x-1/2 before:-translate-y-1/2 kt-menu-item-active:before:bg-primary kt-menu-item-hover:before:bg-primary"))
              concat(content_tag(:span, options[:title], class: "kt-menu-title text-2sm font-normal text-foreground kt-menu-item-active:text-primary kt-menu-item-active:font-semibold kt-menu-link-hover:!text-primary")) if options[:title]
            end
        end
      end

      # Menu heading / section title
      def kt_menu_item_heading(**args)
        # Default options
        options = {
          title: nil,
          uppercase: true,
          class_name: "",
          tag: :div
        }.merge(args)

        # Build item classes
        classes = ["kt-menu-item", "pt-2.25", "pb-px"]
        classes << options[:class_name] if options[:class_name].present?

        final_class = classes.compact.join(" ")

        content_tag(options[:tag], class: final_class) do
          content_tag(:span, options[:title],
            class: "kt-menu-heading #{options[:uppercase] ? 'uppercase' : ''} text-xs font-medium text-muted-foreground ps-[10px] pe-[10px]"
          ) if options[:title]
        end
      end

      # Legacy method aliases for backward compatibility
      def kt_menu_item(*args, **kwargs, &block)
        if args.size == 1 && kwargs.key?(:icon)
          # Old style: kt_menu_item("Title", icon: "icon-class")
          title = args.first
          icon = kwargs[:icon]
          kt_menu_item_accordion(title: title, icon: icon, &block)
        else
          # New style: kt_menu_item(**args, &block)
          kt_menu_item_accordion(*args, **kwargs, &block)
        end
      end

      def kt_menu_link(*args, **kwargs)
        if args.size == 2
          # Old style: kt_menu_link("Title", href: "/url")
          title = args.first
          href = kwargs[:href] || args.last
          kt_menu_item_link(title: title, href: href)
        else
          # New style: kt_menu_link(**args)
          kt_menu_item_link(**kwargs)
        end
      end

      def kt_menu_heading(title)
        kt_menu_item_heading(title: title)
      end
    end
  end
end
