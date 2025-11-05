# app/helpers/kt/menu/item_helper.rb
module KT
  module Menu
    module ItemHelper
      # Membuat elemen menu accordion
      #
      # Contoh:
      # <%= kt_menu_item("Dashboards", icon: "ki-element-11") do %>
      #   <%= kt_menu_link("Light Sidebar", href: "/demo1.html") %>
      #   <%= kt_menu_link("Dark Sidebar", href: "/demo1/dashboards/dark-sidebar.html") %>
      # <% end %>
      #
      def kt_menu_item(title, icon:, &block)
        content_tag :div, class: "kt-menu-item kt-menu-item-accordion", data: { "kt-menu-item-toggle": "accordion", "kt-menu-item-trigger": "click" } do
          concat(
            content_tag(:div,
              class: "kt-menu-link flex items-center grow cursor-pointer border border-transparent gap-[10px] ps-[10px] pe-[10px] py-[6px]",
              tabindex: "0"
            ) do
              concat(content_tag(:span, class: "kt-menu-icon items-start text-muted-foreground w-[20px]") do
                content_tag(:i, "", class: "ki-filled #{icon} text-lg")
              end)

              concat(content_tag(:span, title,
                class: "kt-menu-title text-sm font-medium text-foreground kt-menu-item-active:text-primary kt-menu-link-hover:!text-primary"
              ))

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

          concat(content_tag(:div,
            class: "kt-menu-accordion gap-1 ps-[10px] relative before:absolute before:start-[20px] before:top-0 before:bottom-0 before:border-s before:border-border",
            style: "height: 0px;"
          ) do
            capture(&block)
          end)
        end
      end

      # Membuat link di dalam menu accordion
      def kt_menu_link(title, href:)
        content_tag :div, class: "kt-menu-item" do
          link_to href,
            class: "kt-menu-link border border-transparent items-center grow kt-menu-item-active:bg-accent/60 dark:menu-item-active:border-border kt-menu-item-active:rounded-lg hover:bg-accent/60 hover:rounded-lg gap-[14px] ps-[10px] pe-[10px] py-[8px]",
            tabindex: "0" do
              concat(content_tag(:span, "", class: "kt-menu-bullet flex w-[6px] -start-[3px] rtl:start-0 relative before:absolute before:top-0 before:size-[6px] before:rounded-full rtl:before:translate-x-1/2 before:-translate-y-1/2 kt-menu-item-active:before:bg-primary kt-menu-item-hover:before:bg-primary"))
              concat(content_tag(:span, title, class: "kt-menu-title text-2sm font-normal text-foreground kt-menu-item-active:text-primary kt-menu-item-active:font-semibold kt-menu-link-hover:!text-primary"))
            end
        end
      end

      # Membuat heading / section title di sidebar
      #
      # Contoh:
      # <%= kt_menu_heading("User") %>
      #
      def kt_menu_heading(title)
        content_tag :div, class: "kt-menu-item pt-2.25 pb-px" do
          content_tag(:span, title,
            class: "kt-menu-heading uppercase text-xs font-medium text-muted-foreground ps-[10px] pe-[10px]"
          )
        end
      end
    end
  end
end
