# app/helpers/kt/content_helper.rb
#
# KT Content Helper - Provides layout and content wrapper components
#
# Usage Examples:
#
# 1. Main content wrapper:
#    <%= kt_main_content(class_name: "custom-content") do %>
#      <!-- page content -->
#    <% end %>
#
# 2. Content container:
#    <%= kt_content_container(fixed: true, id: "main-container") do %>
#      <!-- container content -->
#    <% end %>
#
# 3. Content grid:
#    <%= kt_content_grid(cols: 3, gap: "gap-6") do %>
#      <!-- grid items -->
#    <% end %>
#
# 4. Page wrapper:
#    <%= kt_page(max_width: "7xl", centered: true) do %>
#      <!-- page content -->
#    <% end %>
#
# 5. Section wrapper:
#    <%= kt_section(padding: "py-8", margin_bottom: "mb-8") do %>
#      <!-- section content -->
#    <% end %>
#
module KT
  module ContentHelper
    # =====================
    # Content helper - Redesigned with **args, &block
    # =====================

    def kt_main_content(**args, &block)
      # Default options
      options = {
        class_name: "",
        id: "content",
        role: "content",
        tag: :main,
        padding_top: "pt-5",
        grow: true
      }.merge(args)

      # Build classes
      classes = []
      classes << "grow" if options[:grow]
      classes << options[:padding_top] if options[:padding_top]
      classes << options[:class_name] if options[:class_name].present?

      final_class = classes.compact.join(" ")

      content_tag(options[:tag], class: final_class, id: options[:id], role: options[:role]) do
        if block_given?
          capture(&block)
        else
          ""
        end
      end
    end

    # Container fixed di dalam content
    def kt_content_container(**args, &block)
      # Default options
      options = {
        class_name: "",
        id: "contentContainer",
        fixed: true,
        max_width: nil,
        tag: :div
      }.merge(args)

      # Build classes
      classes = []
      classes << "kt-container-fixed" if options[:fixed]

      # Max width options
      max_width_map = {
        sm: "max-w-sm",
        md: "max-w-md",
        lg: "max-w-lg",
        xl: "max-w-xl",
        "2xl": "max-w-2xl",
        "3xl": "max-w-3xl",
        "4xl": "max-w-4xl",
        "5xl": "max-w-5xl",
        "6xl": "max-w-6xl",
        "7xl": "max-w-7xl",
        full: "max-w-full"
      }
      classes << max_width_map[options[:max_width]] if options[:max_width] && max_width_map[options[:max_width]]

      classes << options[:class_name] if options[:class_name].present?

      final_class = classes.compact.join(" ")

      content_tag(options[:tag], class: final_class, id: options[:id]) do
        if block_given?
          capture(&block)
        else
          ""
        end
      end
    end

    # Container grid di dalam content
    def kt_content_grid(**args, &block)
      # Default options
      options = {
        class_name: "",
        id: nil,
        cols: nil,
        gap: "gap-5 lg:gap-7.5",
        responsive: true,
        tag: :div
      }.merge(args)

      # Build classes
      classes = ["grid"]

      # Gap
      classes << options[:gap] if options[:gap]

      # Responsive columns
      if options[:cols]
        cols_value = options[:cols].is_a?(Numeric) ? "#{options[:cols]}" : options[:cols].to_s
        classes << "grid-cols-#{cols_value}"
      end

      classes << options[:class_name] if options[:class_name].present?

      final_class = classes.compact.join(" ")

      content_tag(options[:tag], class: final_class, id: options[:id]) do
        if block_given?
          capture(&block)
        else
          ""
        end
      end
    end

    # Page wrapper for full page layouts
    def kt_page(**args, &block)
      # Default options
      options = {
        class_name: "",
        id: nil,
        padding: "px-4 sm:px-6 lg:px-8",
        max_width: "max-w-7xl",
        centered: true,
        tag: :div
      }.merge(args)

      # Build classes
      classes = []
      classes << options[:padding] if options[:padding]
      classes << options[:max_width] if options[:max_width]
      classes << "mx-auto" if options[:centered]
      classes << options[:class_name] if options[:class_name].present?

      final_class = classes.compact.join(" ")

      content_tag(options[:tag], class: final_class, id: options[:id]) do
        if block_given?
          capture(&block)
        else
          ""
        end
      end
    end

    # Section wrapper
    def kt_section(**args, &block)
      # Default options
      options = {
        class_name: "",
        id: nil,
        padding: "py-6 lg:py-8",
        margin_bottom: "mb-6 lg:mb-8",
        tag: :div
      }.merge(args)

      # Build classes
      classes = []
      classes << options[:padding] if options[:padding]
      classes << options[:margin_bottom] if options[:margin_bottom]
      classes << options[:class_name] if options[:class_name].present?

      final_class = classes.compact.join(" ")

      content_tag(options[:tag], class: final_class, id: options[:id]) do
        if block_given?
          capture(&block)
        else
          ""
        end
      end
    end
  end
end
