module KT
  module SidebarHelper
    # Helper wrapper untuk sidebar
    #
    # @param html_options [Hash] opsional, tambahan class/id/data-attributes
    # @param block [Block] konten sidebar (header, menu, dll)
    #
    def kt_sidebar(html_options = {}, &block)
      default_classes = "kt-sidebar bg-background border-e border-e-border fixed top-0 bottom-0 z-20 hidden lg:flex flex-col items-stretch shrink-0 [--kt-drawer-enable:true] lg:[--kt-drawer-enable:false]"
      default_data    = { "kt-drawer": "true", "kt-drawer-class": "kt-drawer kt-drawer-start top-0 bottom-0" }

      options = {
        class: [default_classes, html_options[:class]].compact.join(" "),
        id: html_options[:id] || "sidebar",
        data: default_data.merge(html_options[:data] || {})
      }

      content_tag(:div, options) do
        capture(&block) if block_given?
      end
    end
  end
end
