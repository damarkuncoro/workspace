module KT
  module UI
    module UiHelper
      include KT::UI::Base::BaseUIHelper
      include KT::UI::Base::BaseMenuHelper
      include KT::UI::Base::BaseDropdownHelper
      include KT::UI::CardHelper
      include KT::UI::Features::HeaderHelper
      include KT::UI::Profile::UiHelper
      include KT::UI::Chat::MessagesHelper
      include KT::UI::Communication::ChatbubbleComponent

      # ===============================
      # 🔹 LAYOUT COMPONENTS
      # ===============================

      # ✅ SRP: Container component
      def ui_container(children:, class: "")
        content_tag(:div, children, class: build_classes("kt-container", class.presence))
      end

      # ✅ SRP: Row component
      def ui_row(children:, class: "")
        content_tag(:div, children, class: build_classes("kt-row", class.presence))
      end

      # ✅ SRP: Column component
      def ui_column(children:, class: "")
        content_tag(:div, children, class: build_classes("kt-column", class.presence))
      end

      # ✅ SRP: Grid column with span and gap
      def ui_grid_column(span: 1, gap: "gap-5 lg:gap-7.5", column_class: "col-span-#{span}", inner_class: "grid #{gap}", &block)
        content_tag(:div, class: build_classes("col-span-#{span}", column_class.presence)) do
          if inner_class.present?
            content_tag(:div, class: build_classes("grid #{gap}", inner_class.presence)) do
              capture(&block)
            end
          else
            capture(&block)
          end
        end
      end

      # ✅ SRP: Dynamic container for layout
      def ui_grid_container(columns: 3, gap: "gap-5 lg:gap-7.5", container_class: "kt-container-fixed", grid_class: nil, &block)
        grid_class ||= "grid grid-cols-1 xl:grid-cols-#{columns} #{gap} py-5"
        content_tag(:div, class: build_classes("kt-container-fixed", container_class.presence)) do
          content_tag(:div, class: build_classes("grid grid-cols-1 xl:grid-cols-#{columns} #{gap} py-5", grid_class.presence)) do
            capture(&block)
          end
        end
      end

      # ===============================
      # 🔹 ADVANCED CONTAINER COMPONENTS
      # ===============================

      # ✅ SRP: Advanced container with size variants
      def ui_container_advanced(size: :default, padding: :default, centered: false, **options, &block)
        classes = build_advanced_container_classes(size: size, padding: padding, centered: centered)
        content_tag(:div, class: classes, **options, &block)
      end

      # ✅ SRP: Fluid container (full width)
      def ui_container_fluid(padding: :default, **options, &block)
        classes = build_advanced_container_classes(size: :fluid, padding: padding)
        content_tag(:div, class: classes, **options, &block)
      end

      # ✅ SRP: Fixed width container with max-width options
      def ui_container_fixed(max_width: :lg, padding: :default, centered: true, **options, &block)
        classes = build_advanced_container_classes(size: :fixed, max_width: max_width, padding: padding, centered: centered)
        content_tag(:div, class: classes, **options, &block)
      end

      # ✅ SRP: Box container with styling variants
      def ui_box(variant: :default, padding: :md, shadow: false, rounded: true, **options, &block)
        classes = build_box_classes(variant: variant, padding: padding, shadow: shadow, rounded: rounded)
        content_tag(:div, class: classes, **options, &block)
      end

      # ===============================
      # 🔹 ENHANCED UI COMPONENTS
      # ===============================

      # ✅ SRP: Enhanced card container - using card_builder
      def ui_card(title:, body:, footer: nil, menu: nil)
        card_builder(type: :standard, title: title, actions: menu ? [ menu ] : nil) do
          content_tag(:div, body, class: "kt-card-body")
        end
      end

      # ✅ SRP: Enhanced dropdown menu - using base menu helpers
      def ui_menu(button_icon:, items:)
        menu_wrapper do
          menu_item_wrapper(data_attrs: {
            "kt-menu-item-toggle": "dropdown",
            "kt-menu-item-trigger": "click",
            "kt-menu-item-placement": "bottom-end"
          }) do
            concat ui_button(icon: button_icon, variant: :ghost, size: :sm, button_class: "kt-menu-toggle kt-btn-icon")
            concat menu_dropdown(data_attrs: { "kt-menu-dismiss": true }, class: "kt-menu-default w-full max-w-[175px]") do
              safe_join(items.map { |item| build_menu_item(item) })
            end
          end
        end
      end

      # ✅ SRP: Enhanced table generator - using base UI table
      def ui_table(headers:, rows: [], &block)
        content_tag(:div, class: build_classes("kt-card-table kt-scrollable-x-auto")) do
          ui_table(headers: headers.map { |h| { title: h[:title] || h, class: h[:class] } }, rows: rows) do |row|
            capture(row, &block) if block_given?
          end
        end
      end

      # ✅ SRP: Enhanced info card - using card_builder
      def ui_info_card(title:, items:)
        card_builder(type: :standard, title: title) do
          ui_info_table(items)
        end
      end

      # ===============================
      # 🔹 ENHANCED DATA DISPLAY COMPONENTS
      # ===============================

      # ✅ SRP: Enhanced button component with variants
      def ui_button_enhanced(text: nil, icon: nil, variant: :primary, size: :md, type: :button, disabled: false, loading: false, **options)
        classes = build_enhanced_button_classes(variant: variant, size: size, disabled: disabled, loading: loading)
        options[:disabled] = true if disabled || loading

        button_tag(type: type, class: classes, **options) do
          concat enhanced_loading_spinner if loading
          concat ui_icon(icon_class: "ki-filled #{icon}") if icon && !loading
          concat text if text
        end
      end

      # ✅ SRP: Enhanced badge component
      def ui_badge_enhanced(text:, variant: :default, size: :md, outline: false, **options)
        classes = build_enhanced_badge_class(variant, size, outline)
        content_tag(:span, text, class: classes, **options)
      end

      # ✅ SRP: Enhanced status badge
      def ui_status_badge_enhanced(status:, text: nil, **options)
        status_config = get_enhanced_status_config(status)
        text ||= status_config[:text] || status.to_s.humanize
        ui_badge_enhanced(text: text, variant: status_config[:variant], **options)
      end

      # ✅ SRP: Enhanced card component
      def ui_card_enhanced(variant: :default, padding: :md, shadow: :sm, rounded: true, **options, &block)
        classes = build_enhanced_card_classes(variant: variant, padding: padding, shadow: shadow, rounded: rounded)
        content_tag(:div, class: classes, **options, &block)
      end

      # ===============================
      # 🔹 ENHANCED FORM COMPONENTS
      # ===============================

      # ✅ SRP: Enhanced input field component
      def ui_input_enhanced(name:, type: :text, value: nil, placeholder: nil, label: nil, error: nil, help: nil, required: false, disabled: false, **options)
        wrapper_class = build_form_wrapper_class(error: error)
        input_class = build_form_input_class(disabled: disabled)

        content_tag(:div, class: wrapper_class) do
          concat form_label(text: label, required: required, for: name) if label
          concat text_field_tag(name, value, type: type, placeholder: placeholder, class: input_class, disabled: disabled, required: required, **options)
          concat form_help_text(text: help) if help
          concat form_error_text(text: error) if error
        end
      end

      # ✅ SRP: Enhanced textarea component
      def ui_textarea_enhanced(name:, value: nil, placeholder: nil, label: nil, error: nil, help: nil, required: false, disabled: false, rows: 3, **options)
        wrapper_class = build_form_wrapper_class(error: error)
        textarea_class = build_form_textarea_class(disabled: disabled)

        content_tag(:div, class: wrapper_class) do
          concat form_label(text: label, required: required, for: name) if label
          concat text_area_tag(name, value, placeholder: placeholder, class: textarea_class, disabled: disabled, required: required, rows: rows, **options)
          concat form_help_text(text: help) if help
          concat form_error_text(text: error) if error
        end
      end

      def ui_select_enhanced(name:, options: [], selected: nil, placeholder: "Select an option", label: nil, error: nil, help: nil, required: false, disabled: false, multiple: false, **kwargs)
        wrapper_class = build_form_wrapper_class(error: error)
        select_class = build_form_select_class(disabled: disabled)

        content_tag(:div, class: wrapper_class) do
          concat form_label(text: label, required: required, for: name) if label
          concat build_form_select_element(name: name, options: options, selected: selected, placeholder: placeholder, class: select_class, disabled: disabled, required: required, multiple: multiple, **options)
          concat form_help_text(text: help) if help
          concat form_error_text(text: error) if error
        end
      end

      # ✅ SRP: Enhanced checkbox component
      def ui_checkbox_enhanced(name:, value: "1", checked: false, label: nil, error: nil, help: nil, disabled: false, **options)
        wrapper_class = build_form_wrapper_class(error: error)

        content_tag(:div, class: wrapper_class) do
          concat build_form_checkbox_input(name: name, value: value, checked: checked, disabled: disabled, **options)
          concat form_label(text: label, for: name) if label
          concat form_help_text(text: help) if help
          concat form_error_text(text: error) if error
        end
      end

      # ===============================
      # 🔹 ENHANCED FEEDBACK COMPONENTS
      # ===============================

      # ✅ SRP: Enhanced alert component
      def ui_alert_enhanced(message:, type: :info, dismissible: false, **options)
        classes = build_enhanced_alert_class(type)
        content_tag(:div, class: classes, role: "alert", **options) do
          concat enhanced_alert_icon(type)
          concat enhanced_alert_content(message)
          concat enhanced_alert_dismiss_button if dismissible
        end
      end

      # ✅ SRP: Enhanced spinner component
      def ui_spinner_enhanced(size: :md, color: :primary, **options)
        classes = build_enhanced_spinner_class(size, color)
        content_tag(:div, class: classes, "aria-hidden": "true", **options)
      end

      # ===============================
      # 🔹 ADDITIONAL UI COMPONENTS
      # ===============================

      # ✅ SRP: Form input wrapper
      def ui_form_group(label:, input:, error: nil, help: nil)
        content_tag(:div, class: build_classes("form-group")) do
          concat content_tag(:label, label, class: build_classes("form-label")) if label
          concat input
          concat content_tag(:div, error, class: build_classes("form-error")) if error
          concat content_tag(:div, help, class: build_classes("form-help")) if help
        end
      end

      # ✅ SRP: Status badge with variants
      def ui_status_badge(status:, text: nil)
        text ||= status.to_s.humanize
        type = case status.to_sym
        when :active, :success, :completed then :success
        when :inactive, :error, :failed then :danger
        when :pending, :warning then :warning
        else :default
        end
        ui_badge(text: text, type: type, size: :sm, outline: true)
      end

      # ✅ SRP: Loading spinner
      def ui_spinner(size: :md, color: :primary)
        size_class = case size
        when :sm then "size-4"
        when :lg then "size-8"
        else "size-6"
        end
        color_class = "border-#{color}"
        content_tag(:div, class: build_classes("animate-spin rounded-full border-2 #{color_class} border-t-transparent #{size_class}"))
      end

      # ✅ SRP: Empty state component
      def ui_empty_state(icon:, title:, description: nil, action: nil)
        content_tag(:div, class: build_classes("text-center py-12")) do
          concat ui_icon(icon_class: "ki-filled #{icon}", size: "text-6xl", icon_wrapper_class: build_classes("text-muted-foreground mb-4"))
          concat content_tag(:h3, title, class: build_classes("text-lg font-semibold mb-2"))
          concat content_tag(:p, description, class: build_classes("text-muted-foreground mb-4")) if description
          concat action if action
        end
      end

      # ===============================
      # 🔹 PRIVATE HELPERS
      # ===============================
      private

      def build_menu_item(item)
        case item
        when :separator
          menu_separator
        when Hash
          menu_item_wrapper do
            menu_link(href: item[:href] || "#") do
              concat menu_icon(icon_class: "ki-filled #{item[:icon]}") if item[:icon]
              concat menu_title(title: item[:title])
            end
          end
        else
          ""
        end
      end

      # Card Header (Single Responsibility)
      def ui_card_header(title:, subtitle: nil)
        content_tag(:div, class: build_classes("kt-card-header")) do
          concat content_tag(:h3, title, class: build_classes("kt-card-title"))
          concat content_tag(:p, subtitle, class: build_classes("kt-card-subtitle")) if subtitle
        end
      end

      # Info Table (DRY rendering of key-value pairs)
      def ui_info_table(items:, table_class: "kt-table-auto")
        content_tag(:div, class: build_classes("kt-card-content pt-4 pb-3")) do
          content_tag(:table, class: build_classes("kt-table-auto", table_class.presence)) do
            content_tag(:tbody) do
              safe_join(items.map { |label, value| ui_info_row(label, value) })
            end
          end
        end
      end

      # Row Component — SRP: one responsibility, one row
      def ui_info_row(label, value, label_class: "text-sm text-secondary-foreground pb-3.5 pe-3", value_class: "text-sm text-mono pb-3.5")
        content_tag(:tr) do
          safe_join([
            content_tag(:td, label, class: build_classes("text-sm text-secondary-foreground pb-3.5 pe-3", label_class.presence)),
            content_tag(:td, value, class: build_classes("text-sm text-mono pb-3.5", value_class.presence))
          ])
        end
      end

      # ===============================
      # 🔹 PRIVATE HELPERS
      # ===============================

      # Advanced container class builder
      def build_advanced_container_classes(size:, padding:, centered: false, max_width: nil)
        size_class = case size
        when :sm then "max-w-4xl"
        when :md then "max-w-6xl"
        when :lg then "max-w-7xl"
        when :xl then "max-w-screen-xl"
        when :"2xl" then "max-w-screen-2xl"
        when :fluid then "w-full"
        when :fixed then "container mx-auto"
        end

        width_class = if size == :fixed && max_width
          case max_width
          when :sm then "max-w-2xl"
          when :md then "max-w-4xl"
          when :lg then "max-w-6xl"
          when :xl then "max-w-screen-lg"
          when :"2xl" then "max-w-screen-xl"
          else "max-w-6xl"
          end
        end

        padding_class = case padding
        when :none then ""
        when :sm then "px-4 py-2"
        when :md then "px-6 py-4"
        when :lg then "px-8 py-6"
        when :xl then "px-12 py-8"
        else "px-4 py-4"
        end

        build_classes("kt-container", size_class, width_class, padding_class.presence, centered && "mx-auto")
      end

      # Box class builder
      def build_box_classes(variant:, padding:, shadow:, rounded:)
        variant_class = case variant
        when :default then "bg-background border border-border"
        when :elevated then "bg-background border border-border shadow-lg"
        when :filled then "bg-muted/50 border border-border"
        when :outlined then "border-2 border-primary bg-transparent"
        end

        padding_class = case padding
        when :none then ""
        when :sm then "p-3"
        when :md then "p-4"
        when :lg then "p-6"
        when :xl then "p-8"
        else "p-4"
        end

        build_classes("kt-box", variant_class, padding_class.presence, shadow && "shadow-md", rounded && "rounded-lg")
      end

      # Enhanced button class builder
      def build_enhanced_button_classes(variant:, size:, disabled: false, loading: false)
        variant_class = case variant
        when :primary then "kt-btn-primary"
        when :secondary then "kt-btn-secondary"
        when :outline then "kt-btn-outline"
        when :ghost then "kt-btn-ghost"
        when :danger then "kt-btn-danger"
        when :success then "kt-btn-success"
        when :warning then "kt-btn-warning"
        end

        size_class = case size
        when :xs then "kt-btn-xs"
        when :sm then "kt-btn-sm"
        when :md then "kt-btn-md"
        when :lg then "kt-btn-lg"
        when :xl then "kt-btn-xl"
        end

        build_classes("kt-btn", variant_class, size_class, disabled && "kt-btn-disabled", loading && "kt-btn-loading")
      end

      # Enhanced badge class builder
      def build_enhanced_badge_class(variant, size, outline)
        variant_class = case variant
        when :primary then "kt-badge-primary"
        when :secondary then "kt-badge-secondary"
        when :success then "kt-badge-success"
        when :danger then "kt-badge-danger"
        when :warning then "kt-badge-warning"
        when :info then "kt-badge-info"
        when :light then "kt-badge-light"
        when :dark then "kt-badge-dark"
        else "kt-badge-default"
        end

        size_class = case size
        when :xs then "kt-badge-xs"
        when :sm then "kt-badge-sm"
        when :lg then "kt-badge-lg"
        else "kt-badge-md"
        end

        build_classes("kt-badge", variant_class, size_class, outline && "kt-badge-outline")
      end

      # Enhanced status config
      def get_enhanced_status_config(status)
        case status.to_sym
        when :active, :enabled, :published
          { variant: :success, text: "Active" }
        when :inactive, :disabled, :draft
          { variant: :secondary, text: "Inactive" }
        when :pending, :waiting
          { variant: :warning, text: "Pending" }
        when :error, :failed, :rejected
          { variant: :danger, text: "Error" }
        when :completed, :done
          { variant: :success, text: "Completed" }
        else
          { variant: :default, text: status.to_s.humanize }
        end
      end

      # Enhanced card class builder
      def build_enhanced_card_classes(variant:, padding:, shadow:, rounded:)
        variant_class = case variant
        when :default then "bg-background border border-border"
        when :elevated then "bg-background border border-border shadow-lg"
        when :filled then "bg-muted/50 border border-border"
        when :outlined then "border-2 border-primary bg-transparent"
        when :ghost then "border border-transparent bg-transparent"
        end

        shadow_class = case shadow
        when :none then ""
        when :sm then "shadow-sm"
        when :md then "shadow-md"
        when :lg then "shadow-lg"
        when :xl then "shadow-xl"
        else "shadow-sm"
        end

        padding_class = if padding != :none
          case padding
          when :sm then "p-3"
          when :md then "p-4"
          when :lg then "p-6"
          when :xl then "p-8"
          else "p-4"
          end
        end

        build_classes("kt-card", variant_class, shadow_class.presence, rounded && "rounded-lg", padding_class)
      end

      # Enhanced loading spinner
      def enhanced_loading_spinner
        ui_spinner(size: :sm, color: :current)
      end

      # Form helper methods
      def build_form_wrapper_class(error: nil)
        build_classes("kt-form-group", error && "kt-form-group-error")
      end

      def build_form_input_class(disabled: false)
        build_classes("kt-input", disabled && "kt-input-disabled")
      end

      def build_form_textarea_class(disabled: false)
        build_classes("kt-textarea", disabled && "kt-textarea-disabled")
      end

      def build_form_select_class(disabled: false)
        build_classes("kt-select", disabled && "kt-select-disabled")
      end

      def build_form_select_element(name:, options:, selected:, placeholder:, class:, disabled:, required:, multiple:, **kwargs)
        select_tag(name, class: class, disabled: disabled, required: required, multiple: multiple, **kwargs) do
          concat content_tag(:option, placeholder, value: "", disabled: true, selected: selected.nil?) unless multiple
          safe_join(build_form_select_options(options, selected, multiple))
        end
      end

      def build_form_select_options(options, selected, multiple)
        options.map do |option|
          value, text = option.is_a?(Array) ? option : [option, option]
          is_selected = multiple ? selected&.include?(value.to_s) : selected.to_s == value.to_s
          content_tag(:option, text, value: value, selected: is_selected)
        end
      end

      def build_form_checkbox_input(name:, value:, checked:, disabled:, **options)
        content_tag(:div, class: "flex items-center") do
          check_box_tag(name, value, checked, class: "kt-checkbox", disabled: disabled, **options)
        end
      end

      def form_label(text:, required: false, for: nil)
        content_tag(:label, for: for, class: build_classes("kt-label")) do
          concat text
          concat content_tag(:span, "*", class: "text-red-500 ml-1") if required
        end
      end

      def form_help_text(text:)
        content_tag(:p, text, class: build_classes("kt-help-text text-sm text-muted-foreground mt-1"))
      end

      def form_error_text(text:)
        content_tag(:p, text, class: build_classes("kt-error-text text-sm text-red-500 mt-1"))
      end

      # Enhanced alert helpers
      def build_enhanced_alert_class(type)
        type_class = case type
        when :success then "kt-alert-success"
        when :error, :danger then "kt-alert-error"
        when :warning then "kt-alert-warning"
        when :info then "kt-alert-info"
        else "kt-alert-info"
        end

        build_classes("kt-alert", type_class)
      end

      def enhanced_alert_icon(type)
        icon_name = case type
        when :success then "check-circle"
        when :error, :danger then "x-circle"
        when :warning then "alert-triangle"
        when :info then "info"
        else "info"
        end
        ui_icon(icon_class: "ki-filled ki-#{icon_name}", size: "text-base")
      end

      def enhanced_alert_content(message)
        content_tag(:div, class: build_classes("kt-alert-content")) do
          content_tag(:p, message, class: build_classes("text-sm"))
        end
      end

      def enhanced_alert_dismiss_button
        content_tag(:button, class: build_classes("kt-alert-dismiss"), type: "button", "aria-label": "Dismiss alert") do
          ui_icon(icon_class: "ki-filled ki-x", size: "text-base")
        end
      end

      # Enhanced spinner helpers
      def build_enhanced_spinner_class(size, color)
        size_class = case size
        when :xs then "w-3 h-3"
        when :sm then "w-4 h-4"
        when :md then "w-6 h-6"
        when :lg then "w-8 h-8"
        when :xl then "w-12 h-12"
        else "w-6 h-6"
        end

        color_class = case color
        when :primary then "text-primary"
        when :secondary then "text-secondary"
        when :muted then "text-muted-foreground"
        when :white then "text-white"
        else "text-primary"
        end

        build_classes("kt-spinner", "inline-block animate-spin rounded-full border-2 border-current border-t-transparent", size_class, color_class)
      end
    end
  end
end
