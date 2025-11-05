# app/helpers/kt/menu/sidebar_helper.rb
module KT
  module Sidebar
    module ContentHelper
      def kt_sidebar_content(&block)
        content_tag :div, class: "kt-sidebar-content flex grow shrink-0 py-5 pe-2", id: "sidebar_content" do
          content_tag(:div,
            class: "kt-scrollable-y-hover grow shrink-0 flex ps-2 lg:ps-5 pe-1 lg:pe-3",
            data: {
              kt_scrollable: true,
              "kt-scrollable-dependencies": "#sidebar_header",
              "kt-scrollable-height": "auto",
              "kt-scrollable-offset": "0px",
              "kt-scrollable-wrappers": "#sidebar_content"
            },
            id: "sidebar_scrollable"
          ) do
            content_tag(:div,
              capture(&block),
              class: "kt-menu flex flex-col grow gap-1",
              data: { kt_menu: true, "kt-menu-accordion-expand-all": false },
              id: "sidebar_menu"
            )
          end
        end
      end
    end
  end
end
