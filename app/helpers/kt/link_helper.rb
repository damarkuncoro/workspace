module KT
  module LinkHelper
    # =====================
    # Link helper - Redesigned with **args, &block
    # =====================

    def kt_link(**args, &block)
      # Default options
      options = {
        text: nil,
        url: nil,
        class_name: "",
        underlined: false,
        dashed: false,
        external: false,
        disabled: false,
        size: nil,
        variant: nil,
        tag: :a
      }.merge(args)

      # Handle legacy positional arguments for backward compatibility
      if args[:text] && args[:url].nil? && block_given?
        # Block usage: kt_link("/url", class: "optional") do ... end
        options[:url] = args[:text]
        options[:text] = nil
      end

      # Build link classes
      classes = ["kt-link"]

      # Style variants
      classes << "kt-link-underlined" if options[:underlined]
      classes << "kt-link-dashed" if options[:dashed]

      # Size variants
      size_map = {
        sm: "kt-link-sm",
        lg: "kt-link-lg"
      }
      classes << size_map[options[:size]] if options[:size] && size_map[options[:size]]

      # Color variants
      variant_map = {
        primary: "kt-link-primary",
        secondary: "kt-link-secondary",
        success: "kt-link-success",
        warning: "kt-link-warning",
        danger: "kt-link-danger",
        info: "kt-link-info"
      }
      classes << variant_map[options[:variant]] if options[:variant] && variant_map[options[:variant]]

      # State classes
      classes << "kt-link-disabled" if options[:disabled]

      # Custom class
      classes << options[:class_name] if options[:class_name].present?

      final_class = classes.compact.join(" ")

      # Build link options
      link_options = { class: final_class }

      # External link attributes
      if options[:external]
        link_options[:target] = "_blank"
        link_options[:rel] = "noopener noreferrer"
      end

      # Handle different usage patterns
      if block_given?
        # Block usage
        link_to options[:url], link_options do
          capture(&block)
        end
      elsif options[:text] && options[:url]
        # Standard usage with text and url
        link_to options[:text], options[:url], link_options
      else
        # Invalid usage
        content_tag(:span, "Invalid link configuration", class: "text-red-500")
      end
    end

    # Legacy helper methods for backward compatibility
    def kt_link_underlined(**args, &block)
      kt_link(**args.merge(underlined: true), &block)
    end

    def kt_link_dashed(**args, &block)
      kt_link(**args.merge(dashed: true), &block)
    end

    # Convenience methods for common link patterns
    def kt_link_primary(**args, &block)
      kt_link(**args.merge(variant: :primary), &block)
    end

    def kt_link_external(**args, &block)
      kt_link(**args.merge(external: true), &block)
    end

    def kt_link_button(**args, &block)
      kt_link(**args.merge(class_name: "inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md"), &block)
    end

    private

    # Merge class string tanpa menimpa class sebelumnya
    def merge_classes(*classes)
      classes.compact.join(" ")
    end
  end
end
