# app/helpers/kt/components/autocomplete_component.rb
module KT::Components::AutocompleteComponent
  include KT::BaseUiHelper
  include KT::BaseDropdownHelper

  # ✅ SRP: Basic autocomplete component
  def ui_autocomplete(name:, options: [], value: nil, placeholder: "Search...", multiple: false, **input_options)
    autocomplete_id = input_options[:id] || "autocomplete-#{SecureRandom.hex(4)}"
    classes = build_autocomplete_class(input_options.delete(:class))

    content_tag(:div, class: "kt-autocomplete-wrapper", data: { "kt-autocomplete": true }) do
      concat autocomplete_input(name, value, placeholder, multiple, autocomplete_id, classes, input_options)
      concat autocomplete_dropdown(autocomplete_id)
      concat autocomplete_hidden_inputs(name, value, multiple) if multiple && value.present?
    end
  end

  # ✅ SRP: Autocomplete with custom data source
  def ui_autocomplete_remote(name:, url:, value: nil, placeholder: "Search...", **options)
    autocomplete_id = options[:id] || "autocomplete-remote-#{SecureRandom.hex(4)}"
    classes = build_autocomplete_class(options.delete(:class))

    content_tag(:div, class: "kt-autocomplete-remote-wrapper", data: { "kt-autocomplete-remote": true, "kt-autocomplete-url": url }) do
      concat autocomplete_input(name, value, placeholder, false, autocomplete_id, classes, options)
      concat autocomplete_dropdown(autocomplete_id)
    end
  end

  # ✅ SRP: Search input with suggestions
  def ui_search_input(name:, suggestions: [], placeholder: "Search...", **options)
    search_id = options[:id] || "search-#{SecureRandom.hex(4)}"
    classes = build_search_class(options.delete(:class))

    content_tag(:div, class: "kt-search-input-wrapper relative") do
      concat search_input_field(name, placeholder, search_id, classes, options)
      concat search_suggestions(suggestions, search_id)
    end
  end

  private

  def autocomplete_input(name, value, placeholder, multiple, autocomplete_id, classes, options)
    if multiple
      text_field_tag("#{name}_text", "", placeholder: placeholder, class: classes,
                     data: { "kt-autocomplete-input": true, "kt-autocomplete-target": autocomplete_id, "kt-autocomplete-multiple": true }, **options)
    else
      text_field_tag(name, value, placeholder: placeholder, class: classes,
                     data: { "kt-autocomplete-input": true, "kt-autocomplete-target": autocomplete_id }, **options)
    end
  end

  def autocomplete_dropdown(autocomplete_id)
    content_tag(:div, class: "kt-autocomplete-dropdown hidden", data: { "kt-autocomplete-dropdown": autocomplete_id }) do
      content_tag(:ul, class: "kt-autocomplete-list max-h-60 overflow-y-auto") do
        # Options will be populated by JavaScript
        content_tag(:li, "No results found", class: "kt-autocomplete-empty p-3 text-muted-foreground text-sm")
      end
    end
  end

  def autocomplete_hidden_inputs(name, value, multiple)
    return unless multiple && value.is_a?(Array)

    safe_join(value.map do |val|
      hidden_field_tag("#{name}[]", val)
    end)
  end

  def search_input_field(name, placeholder, search_id, classes, options)
    content_tag(:div, class: "relative") do
      concat text_field_tag(name, "", placeholder: placeholder, class: classes,
                           data: { "kt-search-input": true, "kt-search-target": search_id }, **options)
      concat search_icon
    end
  end

  def search_icon
    content_tag(:div, class: "absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none") do
      ui_icon(name: "search", size: :sm, wrapper_class: "text-muted-foreground")
    end
  end

  def search_suggestions(suggestions, search_id)
    return "" if suggestions.empty?

    content_tag(:div, class: "kt-search-suggestions absolute z-10 w-full bg-background border border-border rounded-md shadow-lg mt-1 hidden",
                       data: { "kt-search-suggestions": search_id }) do
      content_tag(:ul, class: "kt-search-list max-h-60 overflow-y-auto py-1") do
        safe_join(suggestions.map do |suggestion|
          content_tag(:li, class: "kt-search-item") do
            link_to(suggestion[:text], suggestion[:href] || "#", class: "block px-4 py-2 text-sm hover:bg-accent hover:text-accent-foreground")
          end
        end)
      end
    end
  end

  def build_autocomplete_class(additional_class)
    classes = ["kt-autocomplete-input", "kt-input"]
    classes << additional_class if additional_class
    classes.join(" ")
  end

  def build_search_class(additional_class)
    classes = ["kt-search-input", "kt-input", "pl-10"]
    classes << additional_class if additional_class
    classes.join(" ")
  end
end