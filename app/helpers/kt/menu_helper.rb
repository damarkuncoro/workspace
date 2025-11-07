module KT
  module MenuHelper
    # =====================
    # Menu helper - Redesigned with **args, &block for kt-menu components
    # =====================

    def kt_menu(**args, &block)
      # Default options
      options = {
        class_name: "",
        vertical: false,
        horizontal: false,
        accordion: false,
        dropdown: false,
        placement: nil,
        offset: nil,
        trigger: "click",
        dismiss: true,
        tag: :div
      }.merge(args)

      # Build menu classes
      classes = ["kt-menu"]

      # Menu types
      classes << "kt-menu-vertical" if options[:vertical]
      classes << "kt-menu-horizontal" if options[:horizontal]
      classes << "kt-menu-accordion" if options[:accordion]
      classes << "kt-menu-dropdown" if options[:dropdown]

      # Custom class
      classes << options[:class_name] if options[:class_name].present?

      final_class = classes.compact.join(" ")

      # Build data attributes
      data_attrs = {}
      data_attrs["kt-menu"] = "true" if options[:accordion] || options[:dropdown]
      data_attrs["kt-menu-dismiss"] = options[:dismiss] if options[:dismiss] && options[:dropdown]

      content_tag(options[:tag], class: final_class, data: data_attrs.presence) do
        if block_given?
          capture(&block)
        else
          ""
        end
      end
    end

    # Menu item wrapper
    def kt_menu_item(**args, &block)
      # Default options
      options = {
        class_name: "",
        active: false,
        show: false,
        toggle: nil,
        trigger: nil,
        placement: nil,
        offset: nil,
        arrow: false,
        bullet: false,
        tag: :div
      }.merge(args)

      # Build item classes
      classes = ["kt-menu-item"]
      classes << "active" if options[:active]
      classes << "show" if options[:show]
      classes << "kt-menu-item-accordion" if options[:toggle] == "accordion"
      classes << "kt-menu-item-dropdown" if options[:toggle] == "dropdown"
      classes << options[:class_name] if options[:class_name].present?

      final_class = classes.compact.join(" ")

      # Build data attributes
      data_attrs = {}
      data_attrs["kt-menu-item-toggle"] = options[:toggle] if options[:toggle]
      data_attrs["kt-menu-item-trigger"] = options[:trigger] if options[:trigger]
      data_attrs["kt-menu-item-placement"] = options[:placement] if options[:placement]
      data_attrs["kt-menu-item-offset"] = options[:offset] if options[:offset]

      content_tag(options[:tag], class: final_class, data: data_attrs.presence) do
        if block_given?
          capture(&block)
        else
          ""
        end
      end
    end

    # Menu link
    def kt_menu_link(**args, &block)
      # Default options
      options = {
        href: "#",
        class_name: "",
        active: false,
        hover: true,
        arrow: false,
        bullet: false,
        icon: nil,
        title: nil,
        external: false,
        disabled: false,
        tag: :a
      }.merge(args)

      # Build link classes
      classes = ["kt-menu-link"]

      # States
      classes << "active" if options[:active]
      classes << "hover" if options[:hover]
      classes << "disabled" if options[:disabled]

      # Elements
      classes << "kt-menu-link-arrow" if options[:arrow]
      classes << "kt-menu-link-bullet" if options[:bullet]

      # Custom class
      classes << options[:class_name] if options[:class_name].present?

      final_class = classes.compact.join(" ")

      # Link attributes
      link_attrs = { class: final_class }
      link_attrs[:href] = options[:href] unless options[:tag] != :a
      link_attrs[:target] = "_blank" if options[:external]
      link_attrs[:rel] = "noopener noreferrer" if options[:external]

      content_tag(options[:tag], link_attrs) do
        content = []

        # Bullet
        if options[:bullet]
          content << content_tag(:span, "",
            class: "kt-menu-bullet flex w-[6px] -start-[3px] relative before:absolute before:top-0 before:size-[6px] before:rounded-full before:-translate-y-1/2 kt-menu-item-active:before:bg-primary"
          )
        end

        # Icon
        if options[:icon]
          content << content_tag(:span, class: "kt-menu-icon") do
            content_tag(:i, "", class: "ki-filled #{options[:icon]}")
          end
        end

        # Title
        if options[:title]
          content << content_tag(:span, options[:title], class: "kt-menu-title")
        end

        # Arrow
        if options[:arrow]
          content << content_tag(:span, class: "kt-menu-arrow") do
            content_tag(:i, "", class: "ki-filled ki-right text-xs rtl:transform rtl:rotate-180")
          end
        end

        # Custom block content
        if block_given?
          content << capture(&block)
        end

        safe_join(content)
      end
    end

    # Menu separator
    def kt_menu_separator(**args)
      options = {
        class_name: "",
        tag: :div
      }.merge(args)

      classes = ["kt-menu-separator", options[:class_name]].compact.join(" ")

      content_tag(options[:tag], "", class: classes)
    end

    # Menu heading
    def kt_menu_heading(title, **args)
      options = {
        class_name: "",
        uppercase: true,
        tag: :div
      }.merge(args)

      classes = ["kt-menu-heading"]
      classes << "uppercase" if options[:uppercase]
      classes << options[:class_name] if options[:class_name].present?

      final_class = classes.compact.join(" ")

      content_tag(options[:tag], class: final_class) do
        content_tag(:span, title)
      end
    end

    # Menu toggle button
    def kt_menu_toggle(**args, &block)
      options = {
        class_name: "",
        icon: "ki-dots-vertical",
        size: "sm",
        variant: "ghost",
        tag: :button
      }.merge(args)

      classes = ["kt-menu-toggle", "kt-btn"]
      classes << "kt-btn-#{options[:size]}" if options[:size]
      classes << "kt-btn-#{options[:variant]}" if options[:variant]
      classes << options[:class_name] if options[:class_name].present?

      final_class = classes.compact.join(" ")

      content_tag(options[:tag], class: final_class, type: "button") do
        if block_given?
          capture(&block)
        else
          content_tag(:i, "", class: "ki-filled #{options[:icon]}")
        end
      end
    end

    # Menu dropdown
    def kt_menu_dropdown(**args, &block)
      options = {
        class_name: "",
        width: nil,
        max_width: nil,
        placement: "bottom-start",
        tag: :div
      }.merge(args)

      classes = ["kt-menu-dropdown"]
      classes << options[:class_name] if options[:class_name].present?

      final_class = classes.compact.join(" ")

      style_attrs = {}
      style_attrs[:width] = options[:width] if options[:width]
      style_attrs[:maxWidth] = options[:max_width] if options[:max_width]

      content_tag(options[:tag], class: final_class, style: style_attrs.presence, data: { "kt-menu-placement": options[:placement] }) do
        if block_given?
          capture(&block)
        else
          ""
        end
      end
    end
  end
end
