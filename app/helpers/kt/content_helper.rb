module KT
  module ContentHelper
    # Wrapper utama untuk content
    #
    # @param html_options [Hash] opsional class/id
    # @param block [Block] konten utama
    def kt_main_content(html_options = {}, &block)
      default_classes = "grow pt-5"
      options = {
        class: [default_classes, html_options[:class]].compact.join(" "),
        id: html_options[:id] || "content",
        role: "content"
      }

      content_tag(:main, options) do
        capture(&block) if block_given?
      end
    end

    # Container fixed di dalam content
    #
    # @param html_options [Hash] opsional class/id
    # @param block [Block] konten container
    def kt_content_container(html_options = {}, &block)
      default_classes = "kt-container-fixed"
      options = {
        class: [default_classes, html_options[:class]].compact.join(" "),
        id: html_options[:id] || "contentContainer"
      }

      content_tag(:div, options) do
        capture(&block) if block_given?
      end
    end

    # Container grid di dalam content
    #
    # @param html_options [Hash] opsional class/id
    # @param block [Block] konten grid
    def kt_content_grid(html_options = {}, &block)
      default_classes = "grid gap-5 lg:gap-7.5"
      options = {
        class: [default_classes, html_options[:class]].compact.join(" "),
        id: html_options[:id]
      }

      content_tag(:div, options) do
        capture(&block) if block_given?
      end
    end
  end
end
