module KT
  module FooterHelper
    # =====================
    # Footer helper - Redesigned with **args, &block
    # =====================

    def kt_footer(**args, &block)
      # Default options
      options = {
        year: Time.current.year,
        company: { name: "Keenthemes Inc.", url: "https://keenthemes.com" },
        links: nil,
        class_name: "",
        container_class: "kt-container-fixed",
        content_class: "flex flex-col md:flex-row justify-center md:justify-between items-center gap-3 py-5",
        copyright_class: "flex order-2 md:order-1 gap-2 font-normal text-sm",
        nav_class: "flex order-1 md:order-2 gap-4 font-normal text-sm text-secondary-foreground",
        link_class: "hover:text-primary",
        separator: "©",
        show_copyright: true,
        show_links: true,
        tag: :footer
      }.merge(args)

      # Default links if not provided
      options[:links] ||= [
        { title: "Docs", url: "https://keenthemes.com/metronic/tailwind/docs" },
        { title: "Purchase", url: "https://1.envato.market/Vm7VRE" },
        { title: "FAQ", url: "https://keenthemes.com/metronic/tailwind/docs/getting-started/license" },
        { title: "Support", url: "https://devs.keenthemes.com" },
        { title: "License", url: "https://keenthemes.com/metronic/tailwind/docs/getting-started/license" }
      ] if options[:show_links]

      # Build footer classes
      footer_classes = ["kt-footer", options[:class_name]].compact.join(" ")

      content_tag options[:tag], class: footer_classes do
        content_tag :div, class: options[:container_class] do
          if block_given?
            # Custom footer content
            capture(&block)
          else
            # Default footer structure
            content_tag :div, class: options[:content_class] do
              elements = []

              # Copyright & Company section
              if options[:show_copyright]
                elements << content_tag(:div, class: options[:copyright_class]) do
                  copyright_parts = []
                  copyright_parts << content_tag(:span, "#{options[:year]}#{options[:separator]}", class: "text-secondary-foreground") if options[:year]
                  copyright_parts << link_to(options[:company][:name], options[:company][:url], class: "text-secondary-foreground hover:text-primary") if options[:company]
                  safe_join(copyright_parts)
                end
              end

              # Footer links section
              if options[:show_links] && options[:links].present?
                elements << content_tag(:nav, class: options[:nav_class]) do
                  safe_join(options[:links].map { |link|
                    link_to(link[:title], link[:url], class: options[:link_class])
                  })
                end
              end

              safe_join(elements)
            end
          end
        end
      end
    end

    # Convenience methods for common footer patterns
    def kt_footer_simple(**args, &block)
      kt_footer(**args.merge(show_links: false), &block)
    end

    def kt_footer_minimal(**args, &block)
      kt_footer(**args.merge(show_copyright: false, show_links: false), &block)
    end

    def kt_footer_custom(**args, &block)
      kt_footer(**args, &block)
    end
  end
end
