# app/helpers/kt/components/flex_component.rb
module KT::Components::FlexComponent
  include KT::UI::Base::BaseUIHelper

  # ✅ SRP: Flexbox container component
  def ui_flex(direction: :row, justify: :start, align: :stretch, wrap: :nowrap, gap: :none, **options, &block)
    classes = build_flex_classes(direction: direction, justify: justify, align: align, wrap: wrap, gap: gap)
    content_tag(:div, class: classes, **options, &block)
  end

  # ✅ SRP: Horizontal flex (row)
  def ui_flex_row(justify: :start, align: :center, gap: :md, **options, &block)
    ui_flex(direction: :row, justify: justify, align: align, gap: gap, **options, &block)
  end

  # ✅ SRP: Vertical flex (column)
  def ui_flex_col(justify: :start, align: :stretch, gap: :md, **options, &block)
    ui_flex(direction: :col, justify: justify, align: align, gap: gap, **options, &block)
  end

  # ✅ SRP: Flex item component
  def ui_flex_item(grow: nil, shrink: nil, basis: nil, order: nil, **options, &block)
    classes = build_flex_item_classes(grow: grow, shrink: shrink, basis: basis, order: order)
    content_tag(:div, class: classes, **options, &block)
  end

  # ✅ SRP: Space component for flex gaps
  def ui_flex_space(&block)
    ui_flex_item(grow: 1, &block)
  end

  # ✅ SRP: Common flex patterns
  def ui_flex_center(gap: :md, direction: :row, **options, &block)
    ui_flex(direction: direction, justify: :center, align: :center, gap: gap, **options, &block)
  end

  def ui_flex_between(gap: :md, **options, &block)
    ui_flex(direction: :row, justify: :between, align: :center, gap: gap, **options, &block)
  end

  def ui_flex_around(gap: :md, **options, &block)
    ui_flex(direction: :row, justify: :around, align: :center, gap: gap, **options, &block)
  end

  def ui_flex_evenly(gap: :md, **options, &block)
    ui_flex(direction: :row, justify: :evenly, align: :center, gap: gap, **options, &block)
  end

  private

  def build_flex_classes(direction:, justify:, align:, wrap:, gap:)
    classes = ["kt-flex", "flex"]

    # Direction
    direction_class = case direction
                      when :row then "flex-row"
                      when :col then "flex-col"
                      when :row_reverse then "flex-row-reverse"
                      when :col_reverse then "flex-col-reverse"
                      else "flex-row"
                      end
    classes << direction_class

    # Justify (main axis alignment)
    justify_class = case justify
                    when :start then "justify-start"
                    when :center then "justify-center"
                    when :end then "justify-end"
                    when :between then "justify-between"
                    when :around then "justify-around"
                    when :evenly then "justify-evenly"
                    else "justify-start"
                    end
    classes << justify_class

    # Align (cross axis alignment)
    align_class = case align
                  when :start then "items-start"
                  when :center then "items-center"
                  when :end then "items-end"
                  when :stretch then "items-stretch"
                  when :baseline then "items-baseline"
                  else "items-stretch"
                  end
    classes << align_class

    # Wrap
    wrap_class = case wrap
                 when :wrap then "flex-wrap"
                 when :nowrap then "flex-nowrap"
                 when :wrap_reverse then "flex-wrap-reverse"
                 else "flex-nowrap"
                 end
    classes << wrap_class

    # Gap
    gap_class = case gap
                when :none then ""
                when :xs then "gap-1"
                when :sm then "gap-2"
                when :md then "gap-4"
                when :lg then "gap-6"
                when :xl then "gap-8"
                when :2xl then "gap-12"
                else ""
                end
    classes << gap_class if gap_class.present?

    classes.join(" ")
  end

  def build_flex_item_classes(grow:, shrink:, basis:, order:)
    classes = ["kt-flex-item"]

    # Flex grow
    classes << "flex-grow" if grow == true
    classes << "flex-grow-0" if grow == false

    # Flex shrink
    classes << "flex-shrink" if shrink == true
    classes << "flex-shrink-0" if shrink == false

    # Flex basis
    if basis
      basis_class = case basis
                    when :auto then "flex-basis-auto"
                    when :full then "flex-basis-full"
                    else "flex-basis-#{basis}"
                    end
      classes << basis_class
    end

    # Order
    classes << "order-#{order}" if order

    classes.join(" ")
  end
end