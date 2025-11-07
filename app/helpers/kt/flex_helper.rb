# app/helpers/kt/flex_helper.rb
#
# KT Flex Helper - Provides flexible layout components using CSS Flexbox
#
# Usage Examples:
#
# 1. Basic flex container:
#    <%= kt_flex(gap: 4, justify: :center, align: :center) do %>
#      <!-- flex items -->
#    <% end %>
#
# 2. Flex row:
#    <%= kt_flex_row(gap: 3, wrap: true) do %>
#      <!-- row items -->
#    <% end %>
#
# 3. Flex column:
#    <%= kt_flex_col(gap: 2, justify: :start) do %>
#      <!-- column items -->
#    <% end %>
#
# 4. Center content:
#    <%= kt_flex_center do %>
#      <!-- centered content -->
#    <% end %>
#
# 5. Space between:
#    <%= kt_flex(gap: 4, justify: :between) do %>
#      <div>Left</div>
#      <div>Right</div>
#    <% end %>
#
module KT
  module FlexHelper
    # =====================
    # Flex helper - Redesigned with **args, &block
    # =====================

    def kt_flex(**args, &block)
      # Default options
      options = {
        direction: :row,        # :row, :col, :row_reverse, :col_reverse
        wrap: false,            # true, false, :wrap, :nowrap, :wrap_reverse
        justify: nil,           # :start, :end, :center, :between, :around, :evenly
        align: nil,             # :start, :end, :center, :baseline, :stretch
        gap: nil,               # Numeric (converted to gap-{n}) or string
        gap_x: nil,             # Numeric or string
        gap_y: nil,             # Numeric or string
        class_name: "",
        inline: false,          # true for inline-flex
        tag: :div
      }.merge(args)

      # Build flex classes
      classes = []

      # Base flex class
      base_class = options[:inline] ? "inline-flex" : "flex"
      classes << base_class

      # Direction
      direction_map = {
        row: "flex-row",
        col: "flex-col",
        row_reverse: "flex-row-reverse",
        col_reverse: "flex-col-reverse"
      }
      classes << direction_map[options[:direction]] if direction_map[options[:direction]]

      # Wrap
      wrap_map = {
        true => "flex-wrap",
        false => "flex-nowrap",
        wrap: "flex-wrap",
        nowrap: "flex-nowrap",
        wrap_reverse: "flex-wrap-reverse"
      }
      classes << wrap_map[options[:wrap]] if options[:wrap] && wrap_map[options[:wrap]]

      # Justify content
      justify_map = {
        start: "justify-start",
        end: "justify-end",
        center: "justify-center",
        between: "justify-between",
        around: "justify-around",
        evenly: "justify-evenly"
      }
      classes << justify_map[options[:justify]] if options[:justify] && justify_map[options[:justify]]

      # Align items
      align_map = {
        start: "items-start",
        end: "items-end",
        center: "items-center",
        baseline: "items-baseline",
        stretch: "items-stretch"
      }
      classes << align_map[options[:align]] if options[:align] && align_map[options[:align]]

      # Gap handling
      if options[:gap]
        gap_value = options[:gap].is_a?(Numeric) ? "#{options[:gap]}" : options[:gap].to_s
        classes << "gap-#{gap_value}"
      end

      if options[:gap_x]
        gap_x_value = options[:gap_x].is_a?(Numeric) ? "#{options[:gap_x]}" : options[:gap_x].to_s
        classes << "gap-x-#{gap_x_value}"
      end

      if options[:gap_y]
        gap_y_value = options[:gap_y].is_a?(Numeric) ? "#{options[:gap_y]}" : options[:gap_y].to_s
        classes << "gap-y-#{gap_y_value}"
      end

      # Add custom class_name
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

    # Legacy helper for backward compatibility
    def flex(**args, &block)
      kt_flex(**args, &block)
    end

    # Convenience methods for common flex patterns
    def kt_flex_row(**args, &block)
      kt_flex(**args.merge(direction: :row), &block)
    end

    def kt_flex_col(**args, &block)
      kt_flex(**args.merge(direction: :col), &block)
    end

    def kt_flex_center(**args, &block)
      kt_flex(**args.merge(justify: :center, align: :center), &block)
    end

    def kt_flex_between(**args, &block)
      kt_flex(**args.merge(justify: :between, align: :center), &block)
    end

    private

    # Utility merge class
    def merge_classes(*classes)
      classes.compact.join(" ")
    end
  end
end
