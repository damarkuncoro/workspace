module KT
  module AvatarHelper
    # =====================
    # Avatar helper (image, ring, text, stack) - Redesigned with **args, &block
    # =====================

    def kt_avatar(**args, &block)
      # Default options
      options = {
        src: nil,
        size: 10,
        size_class: nil,
        ring: true,
        ring_class: "ring-1 ring-background",
        bg_class: "bg-green-500",
        text_class: "text-white text-xs relative inline-flex items-center justify-center",
        hover: true,
        class_name: "",
        type: :image,
        text: nil,
        stack: false,
        stack_class: "flex -space-x-2"
      }.merge(args)

      # Calculate size_class if not provided
      options[:size_class] ||= "size-#{options[:size]}" unless options[:size_class]

      # Build classes array
      classes = ["shrink-0 rounded-full", options[:size_class], options[:class_name]]

      # Add ring class for ring and text types
      classes << options[:ring_class] if options[:ring] && [:ring, :text].include?(options[:type])

      # Add background and text classes for text type
      if options[:type] == :text
        classes << options[:bg_class]
        classes << options[:text_class]
      end

      # Add hover effect
      classes << "hover:z-5" if options[:hover]

      final_class = classes.compact.join(" ")

      case options[:type]
      when :image
        if options[:stack] || options[:src].is_a?(Array)
          content_tag(:div, class: options[:stack_class]) do
            sources = options[:src].is_a?(Array) ? options[:src] : [options[:src]]
            safe_join(sources.map { |s| image_tag(s, class: final_class) })
          end
        else
          image_tag(options[:src], class: final_class)
        end
      when :ring
        image_tag(options[:src], class: final_class)
      when :text
        content_tag(:span, options[:text] || (block_given? ? capture(&block) : ""), class: final_class)
      else
        if block_given?
          content_tag(:div, class: final_class, &block)
        else
          content_tag(:div, "", class: final_class)
        end
      end
    end

    # Legacy helper methods for backward compatibility
    def avatar(**args)
      kt_avatar(**args)
    end

    def avatar_ring(src, **args)
      defaults = { src: src, type: :ring }
      kt_avatar(**defaults.merge(args))
    end

    def avatar_text(text = nil, **args, &block)
      defaults = { type: :text, text: text }
      kt_avatar(**defaults.merge(args), &block)
    end

    def avatar_stack(sources, **args)
      defaults = { src: sources, stack: true }
      kt_avatar(**defaults.merge(args))
    end

    private

    # Merge class tanpa menimpa
    def merge_classes(*classes)
      classes.compact.join(" ")
    end
  end
end
