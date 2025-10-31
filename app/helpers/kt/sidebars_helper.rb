module KT::SidebarsHelper
  include KT::BaseMenuHelper
  include KT::BaseUiHelper

  # ===============================
  # 🔹 MAIN SIDEBAR COMPONENTS
  # ===============================

  # ✅ SRP: Main sidebar menu renderer - optimized and using base helpers
  def render_sidebar_menu(menu_data)
    menu_wrapper(menu_class: 'kt-menu flex flex-col grow gap-1', data_attrs: { 'kt-menu-accordion-expand-all' => false }, id: 'sidebar_menu') do
      safe_join(menu_data.map { |section| render_sidebar_section(section) })
    end
  end

  # ===============================
  # 🔹 PRIVATE HELPERS
  # ===============================
  private

  # Render a section (heading + items)
  def render_sidebar_section(section)
    content = []

    # Add section heading if present
    content << render_section_heading(section[:heading]) if section[:heading]

    # Add menu items
    content << safe_join(section[:items].map { |item| render_menu_item(item) })

    safe_join(content)
  end

  # Render section heading
  def render_section_heading(heading)
    menu_item_wrapper(class: 'kt-menu-item pt-2.25 pb-px') do
      content_tag(:span, heading.upcase, class: 'kt-menu-heading uppercase text-xs font-medium text-muted-foreground ps-[10px] pe-[10px]')
    end
  end

  # Render individual menu item
  def render_menu_item(item)
    if item[:children]
      render_accordion_item(item)
    elsif item[:label]
      render_label_item(item)
    else
      render_simple_item(item)
    end
  end

  # Render accordion menu item (with children)
  def render_accordion_item(item)
    menu_item_wrapper(data_attrs: { 'kt-menu-item-toggle' => 'accordion', 'kt-menu-item-trigger' => 'click' }) do
      concat render_menu_link(item, true)
      concat render_accordion(item[:children])
    end
  end

  # Render simple menu item (no children)
  def render_simple_item(item)
    menu_item_wrapper do
      render_menu_link(item, false)
    end
  end

  # Render menu link - using base helpers
  def render_menu_link(item, has_children = false)
    link_classes = 'kt-menu-link flex items-center grow cursor-pointer border border-transparent gap-[10px] ps-[10px] pe-[10px] py-[6px]'
    link_classes += ' kt-menu-item-active:text-primary kt-menu-link-hover:!text-primary' if has_children

    content_tag(:div, class: link_classes, tabindex: 0) do
      content = []

      # Icon
      content << render_menu_icon(item[:icon]) if item[:icon]

      # Title
      content << render_menu_title(item[:title], has_children)

      # Arrow (for accordion items)
      content << menu_arrow if has_children

      safe_join(content)
    end
  end

  # Render menu icon - using base helper
  def render_menu_icon(icon_class)
    menu_icon(icon_class: "#{icon_class} text-lg", icon_wrapper_class: 'kt-menu-icon items-start text-muted-foreground w-[20px]')
  end

  # Render menu title - using base helper
  def render_menu_title(title, has_children = false)
    title_classes = 'kt-menu-title text-sm font-medium text-foreground'
    title_classes += ' kt-menu-item-active:text-primary kt-menu-link-hover:!text-primary' if has_children

    menu_title(title: title, title_class: title_classes)
  end

  # Render accordion content
  def render_accordion(children)
    content_tag(:div, class: 'kt-menu-accordion gap-1 ps-[10px] relative before:absolute before:start-[20px] before:top-0 before:bottom-0 before:border-s before:border-border') do
      safe_join(children.map { |child| render_child_item(child) })
    end
  end

  # Render child menu item
  def render_child_item(child)
    if child[:children]
      render_nested_accordion_item(child)
    else
      render_child_link(child)
    end
  end

  # Render child link
  def render_child_link(child)
    link_classes = 'kt-menu-link border border-transparent items-center grow kt-menu-item-active:bg-accent/60 dark:menu-item-active:border-border kt-menu-item-active:rounded-lg hover:bg-accent/60 hover:rounded-lg gap-[14px] ps-[10px] pe-[10px] py-[8px]'

    menu_item_wrapper do
      link_to(child[:url] || '#', class: link_classes, tabindex: 0) do
        concat render_menu_bullet
        concat render_child_title(child[:title])
      end
    end
  end

  # Render nested accordion item
  def render_nested_accordion_item(child)
    menu_item_wrapper(data_attrs: { 'kt-menu-item-toggle' => 'accordion', 'kt-menu-item-trigger' => 'click' }) do
      concat render_nested_link(child)
      concat render_nested_accordion(child[:children])
    end
  end

  # Render nested link
  def render_nested_link(child)
    content_tag(:div, class: 'kt-menu-link border border-transparent grow cursor-pointer gap-[14px] ps-[10px] pe-[10px] py-[8px]', tabindex: 0) do
      concat render_menu_bullet
      concat render_nested_title(child[:title])
      concat menu_arrow
    end
  end

  # Render nested accordion
  def render_nested_accordion(children)
    content_tag(:div, class: 'kt-menu-accordion gap-1 relative before:absolute before:start-[32px] ps-[22px] before:top-0 before:bottom-0 before:border-s before:border-border') do
      safe_join(children.map { |grandchild| render_grandchild_item(grandchild) })
    end
  end

  # Render grandchild item
  def render_grandchild_item(grandchild)
    if grandchild[:children]
      render_show_more_item(grandchild)
    else
      render_grandchild_link(grandchild)
    end
  end

  # Render grandchild link
  def render_grandchild_link(grandchild)
    link_classes = 'kt-menu-link border border-transparent items-center grow kt-menu-item-active:bg-accent/60 dark:menu-item-active:border-border kt-menu-item-active:rounded-lg hover:bg-accent/60 hover:rounded-lg gap-[5px] ps-[10px] pe-[10px] py-[8px]'

    menu_item_wrapper do
      link_to(grandchild[:url] || '#', class: link_classes, tabindex: 0) do
        concat render_menu_bullet
        concat render_grandchild_title(grandchild[:title])
      end
    end
  end

  # Render "show more" item
  def render_show_more_item(item)
    menu_item_wrapper(class: 'kt-menu-item flex-col-reverse', data_attrs: { 'kt-menu-item-toggle' => 'accordion', 'kt-menu-item-trigger' => 'click' }) do
      concat render_show_more_link(item)
      concat render_hidden_items(item[:children])
    end
  end

  # Render show more link
  def render_show_more_link(item)
    content_tag(:div, class: 'kt-menu-link border border-transparent grow cursor-pointer gap-[5px] ps-[10px] pe-[10px] py-[8px]', tabindex: 0) do
      concat render_menu_bullet
      concat render_show_more_title(item[:title])
      concat menu_arrow
    end
  end

  # Render hidden items
  def render_hidden_items(children)
    content_tag(:div, class: 'kt-menu-accordion gap-1') do
      safe_join(children.map { |child| render_hidden_item(child) })
    end
  end

  # Render hidden item
  def render_hidden_item(child)
    link_classes = 'kt-menu-link border border-transparent items-center grow kt-menu-item-active:bg-accent/60 dark:menu-item-active:border-border kt-menu-item-active:rounded-lg hover:bg-accent/60 hover:rounded-lg gap-[5px] ps-[10px] pe-[10px] py-[8px]'

    menu_item_wrapper do
      link_to(child[:url] || '#', class: link_classes, tabindex: 0) do
        concat render_menu_bullet
        concat render_grandchild_title(child[:title])
      end
    end
  end

  # Render menu bullet
  def render_menu_bullet
    content_tag(:span, class: 'kt-menu-bullet flex w-[6px] -start-[3px] rtl:start-0 relative before:absolute before:top-0 before:size-[6px] before:rounded-full rtl:before:translate-x-1/2 before:-translate-y-1/2 kt-menu-item-active:before:bg-primary kt-menu-item-hover:before:bg-primary')
  end

  # Render child title
  def render_child_title(title)
    menu_title(title: title, title_class: 'kt-menu-title text-2sm font-normal text-foreground kt-menu-item-active:text-primary kt-menu-item-active:font-semibold kt-menu-link-hover:!text-primary')
  end

  # Render nested title
  def render_nested_title(title)
    menu_title(title: title, title_class: 'kt-menu-title text-2sm font-normal me-1 text-foreground kt-menu-item-active:text-primary kt-menu-item-active:font-medium kt-menu-link-hover:!text-primary')
  end

  # Render grandchild title
  def render_grandchild_title(title)
    menu_title(title: title, title_class: 'kt-menu-title text-2sm font-normal text-foreground kt-menu-item-active:text-primary kt-menu-item-active:font-semibold kt-menu-link-hover:!text-primary')
  end

  # Render show more title
  def render_show_more_title(title)
    content_tag(:span, class: 'kt-menu-title text-2sm font-normal text-secondary-foreground') do
      show_less = content_tag(:span, class: 'hidden kt-menu-item-show:!flex') { 'Show less' }
      show_more = content_tag(:span, class: 'flex kt-menu-item-show:hidden') { title }
      show_less + show_more
    end
  end

  # Render label item (for "Soon" badges)
  def render_label_item(item)
    menu_item_wrapper do
      content_tag(:div, class: 'kt-menu-label border border-transparent gap-[10px] ps-[10px] pe-[10px] py-[6px]', tabindex: 0) do
        content = []

        # Icon
        content << render_menu_icon(item[:icon]) if item[:icon]

        # Title
        content << menu_title(title: item[:title], title_class: 'kt-menu-title text-sm font-medium text-foreground')

        # Badge
        content << render_badge(item[:badge]) if item[:badge]

        safe_join(content)
      end
    end
  end

  # Render badge - using base UI badge
  def render_badge(badge_text)
    content_tag(:span, class: 'kt-menu-badge me-[-10px]') do
      ui_badge(text: badge_text, size: :sm, outline: false, badge_class: 'kt-badge text-accent-foreground/60')
    end
  end
end