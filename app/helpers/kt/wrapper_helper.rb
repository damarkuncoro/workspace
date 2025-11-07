# app/helpers/kt/wrapper_helper.rb
#
# KT Wrapper Helper - Provides layout wrapper components for KT theme
#
# Usage Examples:
#
# 1. Basic wrapper:
#    <%= kt_wrapper do %>
#      <!-- page content -->
#    <% end %>
#
# 2. Custom wrapper:
#    <%= kt_wrapper(class_name: "custom-wrapper", id: "main-wrapper") do %>
#      <!-- page content -->
#    <% end %>
#
# 3. Page wrapper:
#    <%= kt_page_wrapper do %>
#      <%= kt_page_header(title: "Dashboard") %>
#      <%= kt_page_content do %>
#        <!-- main content -->
#      <% end %>
#    <% end %>
#
# 4. Container wrapper:
#    <%= kt_container(size: "xl", centered: true) do %>
#      <!-- container content -->
#    <% end %>
#
module KT
  module WrapperHelper
    # =====================
    # Wrapper helper - Redesigned with **args, &block
    # =====================

    def kt_wrapper(**args, &block)
      # Default options
      options = {
        class_name: "",
        id: nil,
        flex: true,
        grow: true,
        direction: "col",
        tag: :div
      }.merge(args)

      # Build wrapper classes
      classes = ["kt-wrapper"]

      # Layout classes
      classes << "flex" if options[:flex]
      classes << "grow" if options[:grow]
      classes << "flex-#{options[:direction]}" if options[:direction] && options[:flex]

      # Custom class
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

    # Page wrapper - Main page container
    def kt_page_wrapper(**args, &block)
      # Default options
      options = {
        class_name: "",
        id: "page-wrapper",
        max_width: nil,
        centered: false,
        padding: nil,
        tag: :div
      }.merge(args)

      # Build classes
      classes = ["kt-page-wrapper"]

      # Layout
      classes << "mx-auto" if options[:centered]
      classes << "max-w-#{options[:max_width]}" if options[:max_width]
      classes << "p-#{options[:padding]}" if options[:padding]

      # Custom class
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

    # Page header wrapper
    def kt_page_header(**args, &block)
      # Default options
      options = {
        class_name: "",
        id: nil,
        title: nil,
        subtitle: nil,
        actions: nil,
        border: true,
        padding: "px-6 py-4 lg:px-8 lg:py-6",
        tag: :header
      }.merge(args)

      # Build classes
      classes = ["kt-page-header"]
      classes << options[:padding]
      classes << "border-b border-border" if options[:border]
      classes << options[:class_name] if options[:class_name].present?

      final_class = classes.compact.join(" ")

      content_tag(options[:tag], class: final_class, id: options[:id]) do
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
                  title_elements << content_tag(:h1, options[:title], class: "text-2xl font-bold text-foreground") if options[:title]
                  title_elements << content_tag(:p, options[:subtitle], class: "text-sm text-muted-foreground mt-1") if options[:subtitle]
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

    # Page content wrapper
    def kt_page_content(**args, &block)
      # Default options
      options = {
        class_name: "",
        id: nil,
        padding: "px-6 py-6 lg:px-8",
        tag: :main
      }.merge(args)

      # Build classes
      classes = ["kt-page-content"]
      classes << options[:padding]
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

    # Container wrapper
    def kt_container(**args, &block)
      # Default options
      options = {
        class_name: "",
        id: nil,
        size: "lg", # sm, md, lg, xl, 2xl, full
        centered: true,
        padding: nil,
        tag: :div
      }.merge(args)

      # Build classes
      classes = ["kt-container"]

      # Size
      size_map = {
        sm: "max-w-screen-sm",
        md: "max-w-screen-md",
        lg: "max-w-screen-lg",
        xl: "max-w-screen-xl",
        "2xl": "max-w-screen-2xl",
        full: "max-w-full"
      }
      classes << size_map[options[:size]] if size_map[options[:size]]

      classes << "mx-auto" if options[:centered]
      classes << "p-#{options[:padding]}" if options[:padding]
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
