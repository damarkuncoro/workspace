module KT
  module Sidebar
    module HeaderHelper
      def kt_sidebar_header(
        default_logo: "/assets/media/app/default-logo.svg",
        dark_logo: "/assets/media/app/default-logo-dark.svg",
        mini_logo: "/assets/media/app/mini-logo.svg",
        href: "/"
      )
        default_logo_path = asset_path(default_logo)
        dark_logo_path    = asset_path(dark_logo)
        mini_logo_path    = asset_path(mini_logo)

        content_tag(:div, class: "kt-sidebar-header hidden lg:flex items-center relative justify-between px-3 lg:px-6 shrink-0", id: "sidebar_header") do
          safe_join([
            # Light mode logos
            link_to(href, class: "dark:hidden") do
              safe_join([
                image_tag(default_logo_path, class: "default-logo min-h-[22px] max-w-none"),
                image_tag(mini_logo_path, class: "small-logo min-h-[22px] max-w-none")
              ])
            end,
            # Dark mode logos
            link_to(href, class: "hidden dark:block") do
              safe_join([
                image_tag(dark_logo_path, class: "default-logo min-h-[22px] max-w-none"),
                image_tag(mini_logo_path, class: "small-logo min-h-[22px] max-w-none")
              ])
            end,
            # Toggle button
            content_tag(:button, class: "kt-btn kt-btn-outline kt-btn-icon size-[30px] absolute start-full top-2/4 -translate-x-2/4 -translate-y-2/4 rtl:translate-x-2/4",
                        data: { "kt-toggle": "body", "kt-toggle-class": "kt-sidebar-collapse" },
                        id: "sidebar_toggle") do
              content_tag(:i, "", class: "ki-filled ki-black-left-line kt-toggle-active:rotate-180 transition-all duration-300 rtl:translate rtl:rotate-180 rtl:kt-toggle-active:rotate-0")
            end
          ])
        end
      end
    end
  end
end
