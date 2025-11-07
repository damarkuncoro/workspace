module KT
  module CardHelper
    # =====================
    # Card helper - Redesigned with **args, &block
    # =====================

    def kt_card(**args, &block)
      # Default options
      options = {
        class_name: "",
        height: "h-full",
        shadow: true,
        border: true,
        rounded: true,
        padding: nil,
        bg_color: nil,
        hover: false,
        tag: :div
      }.merge(args)

      # Build card classes
      classes = ["kt-card"]

      # Size and layout
      classes << options[:height] if options[:height]

      # Visual effects
      classes << "shadow-lg" if options[:shadow]
      classes << "border border-border" if options[:border]
      classes << "rounded-lg" if options[:rounded]
      classes << "hover:shadow-xl transition-shadow" if options[:hover]

      # Background
      classes << "bg-#{options[:bg_color]}" if options[:bg_color]

      # Padding
      classes << "p-#{options[:padding]}" if options[:padding]

      # Custom class
      classes << options[:class_name] if options[:class_name].present?

      final_class = classes.compact.join(" ")

      content_tag(options[:tag], class: final_class) do
        if block_given?
          capture(&block)
        else
          ""
        end
      end
    end

    # Card header
    def kt_card_header(**args, &block)
      # Default options
      options = {
        class_name: "",
        title: nil,
        subtitle: nil,
        actions: nil,
        border: true,
        padding: "p-4 lg:p-6",
        tag: :div
      }.merge(args)

      # Build header classes
      classes = ["kt-card-header"]
      classes << options[:padding]
      classes << "border-b border-border" if options[:border]
      classes << options[:class_name] if options[:class_name].present?

      final_class = classes.compact.join(" ")

      content_tag(options[:tag], class: final_class) do
        if block_given?
          capture(&block)
        else
          # Default header structure
          header_content = []

          if options[:title] || options[:subtitle] || options[:actions]
            header_content << content_tag(:div, class: "flex items-center justify-between") do
              title_section = []
              if options[:title] || options[:subtitle]
                title_section << content_tag(:div) do
                  title_elements = []
                  title_elements << content_tag(:h3, options[:title], class: "text-lg font-bold text-gray-900") if options[:title]
                  title_elements << content_tag(:p, options[:subtitle], class: "text-sm text-gray-600 mt-1") if options[:subtitle]
                  safe_join(title_elements)
                end
              end

              if options[:actions]
                title_section << content_tag(:div, options[:actions])
              end

              safe_join(title_section)
            end
          end

          safe_join(header_content)
        end
      end
    end

    # Card content
    def kt_card_content(**args, &block)
      # Default options
      options = {
        class_name: "",
        padding: "p-10",
        bg_class: "",
        bg_position: nil,
        bg_size: "bg-no-repeat",
        tag: :div
      }.merge(args)

      # Build content classes
      classes = ["kt-card-content", options[:padding]]

      # Background
      classes << options[:bg_class] if options[:bg_class].present?
      classes << options[:bg_size] if options[:bg_size]
      classes << "bg-#{options[:bg_position]}" if options[:bg_position]

      # Custom class
      classes << options[:class_name] if options[:class_name].present?

      final_class = classes.compact.join(" ")

      content_tag(options[:tag], class: final_class) do
        if block_given?
          capture(&block)
        else
          ""
        end
      end
    end

    # Card footer
    def kt_card_footer(**args, &block)
      # Default options
      options = {
        class_name: "",
        justify: "justify-center",
        padding: "px-6 py-4",
        link_text: nil,
        link_url: "#",
        link_class: "kt-link kt-link-underlined kt-link-dashed",
        border: false,
        tag: :div
      }.merge(args)

      # Build footer classes
      classes = ["kt-card-footer", options[:justify], options[:padding]]
      classes << "border-t border-border" if options[:border]
      classes << options[:class_name] if options[:class_name].present?

      final_class = classes.compact.join(" ")

      content_tag(options[:tag], class: final_class) do
        if block_given?
          capture(&block)
        elsif options[:link_text]
          kt_link(text: options[:link_text], url: options[:link_url], class_name: options[:link_class])
        else
          ""
        end
      end
    end

    # Convenience methods for common card patterns
    def kt_card_simple(**args, &block)
      kt_card(**args.merge(shadow: false, border: false), &block)
    end

    def kt_card_outlined(**args, &block)
      kt_card(**args.merge(shadow: false, border: true), &block)
    end

    def kt_card_elevated(**args, &block)
      kt_card(**args.merge(shadow: true, border: false), &block)
    end

    private

    # Merge class string tanpa menimpa class sebelumnya
    def merge_classes(*classes)
      classes.compact.join(" ")
    end
  end
end
