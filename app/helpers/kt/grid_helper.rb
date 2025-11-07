# app/helpers/kt/grid_helper.rb
#
# KT Grid Helper - Provides responsive grid layout components
#
# Usage Examples:
#
# 1. Basic grid:
#    <%= kt_grid(cols: 3, gap_y: 5, gap_lg: 7.5, items: "stretch") do %>
#      <!-- grid items -->
#    <% end %>
#
# 2. Responsive grid:
#    <%= kt_grid(cols: 1, cols_md: 2, cols_lg: 3, gap: 6) do %>
#      <!-- responsive grid items -->
#    <% end %>
#
# 3. Grid column:
#    <%= kt_column(span: 2, span_lg: 3) do %>
#      <!-- column content -->
#    <% end %>
#
# 4. Convenience methods:
#    <%= kt_grid_2_cols(gap: 4) { content } %>
#    <%= kt_column_full { content } %>
#
module KT
  module GridHelper
    # =====================
    # Grid helper - Redesigned with **args, &block
    # =====================

    def kt_grid(**args, &block)
      # Default options
      options = {
        cols: 3,
        cols_sm: nil,
        cols_md: nil,
        cols_lg: nil,
        cols_xl: nil,
        cols_2xl: nil,
        gap: nil,
        gap_x: nil,
        gap_y: 5,
        gap_sm: nil,
        gap_md: nil,
        gap_lg: 7.5,
        gap_xl: nil,
        gap_2xl: nil,
        items: "stretch",
        justify: nil,
        class_name: "",
        tag: :div
      }.merge(args)

      # Build grid classes
      classes = ["grid"]

      # Responsive column classes
      responsive_cols = {
        "" => options[:cols],
        "sm:" => options[:cols_sm],
        "md:" => options[:cols_md],
        "lg:" => options[:cols_lg],
        "xl:" => options[:cols_xl],
        "2xl:" => options[:cols_2xl]
      }

      responsive_cols.each do |prefix, cols_value|
        if cols_value
          classes << "#{prefix}grid-cols-#{cols_value}"
        end
      end

      # Gap classes
      if options[:gap]
        gap_value = options[:gap].is_a?(Numeric) ? "#{options[:gap]}" : options[:gap].to_s
        classes << "gap-#{gap_value}"
      else
        # Individual gap settings
        gap_settings = {
          "" => options[:gap_y],
          "x:" => options[:gap_x],
          "y:" => options[:gap_y],
          "sm:" => options[:gap_sm],
          "md:" => options[:gap_md],
          "lg:" => options[:gap_lg],
          "xl:" => options[:gap_xl],
          "2xl:" => options[:gap_2xl]
        }

        gap_settings.each do |prefix, gap_value|
          if gap_value
            gap_str = gap_value.is_a?(Numeric) ? "#{gap_value}" : gap_value.to_s
            classes << "#{prefix}gap#{prefix.empty? ? '-y' : ''}-#{gap_str}"
          end
        end
      end

      # Items alignment
      classes << "items-#{options[:items]}" if options[:items]

      # Justify content
      classes << "justify-#{options[:justify]}" if options[:justify]

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

    # Column wrapper - Redesigned with **args, &block
    def kt_column(**args, &block)
      # Default options
      options = {
        span: 2,
        span_sm: nil,
        span_md: nil,
        span_lg: nil,
        span_xl: nil,
        span_2xl: nil,
        start: nil,
        start_sm: nil,
        start_md: nil,
        start_lg: nil,
        start_xl: nil,
        start_2xl: nil,
        class_name: "",
        tag: :div
      }.merge(args)

      # Build column classes
      classes = []

      # Responsive span classes
      responsive_spans = {
        "" => options[:span],
        "sm:" => options[:span_sm],
        "md:" => options[:span_md],
        "lg:" => options[:span_lg],
        "xl:" => options[:span_xl],
        "2xl:" => options[:span_2xl]
      }

      responsive_spans.each do |prefix, span_value|
        if span_value
          classes << "#{prefix}col-span-#{span_value}"
        end
      end

      # Responsive start classes
      responsive_starts = {
        "" => options[:start],
        "sm:" => options[:start_sm],
        "md:" => options[:start_md],
        "lg:" => options[:start_lg],
        "xl:" => options[:start_xl],
        "2xl:" => options[:start_2xl]
      }

      responsive_starts.each do |prefix, start_value|
        if start_value
          classes << "#{prefix}col-start-#{start_value}"
        end
      end

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

    # Legacy helper methods for backward compatibility
    def grid(**args, &block)
      kt_grid(**args, &block)
    end

    def column(**args, &block)
      kt_column(**args, &block)
    end

    # Convenience methods for common grid patterns
    def kt_grid_2_cols(**args, &block)
      kt_grid(**args.merge(cols: 2), &block)
    end

    def kt_grid_4_cols(**args, &block)
      kt_grid(**args.merge(cols: 4), &block)
    end

    def kt_column_full(**args, &block)
      kt_column(**args.merge(span: "full"), &block)
    end

    private

    # Utility merge class
    def merge_classes(*classes)
      classes.compact.join(" ")
    end
  end
end
