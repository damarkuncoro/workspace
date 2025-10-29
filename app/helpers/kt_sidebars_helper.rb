module KtSidebarsHelper
  # Main method to render the sidebar menu
  def render_sidebar_menu(menu_data)
    content_tag(:div, class: 'kt-menu flex flex-col grow gap-1', data: { 'kt-menu' => true, 'kt-menu-accordion-expand-all' => false }, id: 'sidebar_menu') do
      menu_data.map do |section|
        render_sidebar_section(section)
      end.join.html_safe
    end
  end

  private

  # Render a section (heading + items)
  def render_sidebar_section(section)
    content = []

    # Add section heading if present
    if section[:heading]
      content << render_section_heading(section[:heading])
    end

    # Add menu items
    content << section[:items].map do |item|
      render_menu_item(item)
    end.join.html_safe

    content.join.html_safe
  end

  # Render section heading
  def render_section_heading(heading)
    content_tag(:div, class: 'kt-menu-item pt-2.25 pb-px') do
      content_tag(:span, heading.upcase, class: 'kt-menu-heading uppercase text-xs font-medium text-muted-foreground ps-[10px] pe-[10px]')
    end
  end

  # Render individual menu item
  def render_menu_item(item)
    if item[:children]
      render_accordion_item(item)
    else
      render_simple_item(item)
    end
  end

  # Render accordion menu item (with children)
  def render_accordion_item(item)
    content_tag(:div, class: 'kt-menu-item', data: { 'kt-menu-item-toggle' => 'accordion', 'kt-menu-item-trigger' => 'click' }) do
      # Main link
      main_link = render_menu_link(item, true)

      # Children accordion
      accordion = render_accordion(item[:children])

      main_link + accordion
    end
  end

  # Render simple menu item (no children)
  def render_simple_item(item)
    content_tag(:div, class: 'kt-menu-item') do
      render_menu_link(item, false)
    end
  end

  # Render menu link
  def render_menu_link(item, has_children = false)
    link_classes = 'kt-menu-link flex items-center grow cursor-pointer border border-transparent gap-[10px] ps-[10px] pe-[10px] py-[6px]'
    link_classes += ' kt-menu-item-active:text-primary kt-menu-link-hover:!text-primary' if has_children

    content_tag(:div, class: link_classes, tabindex: 0) do
      content = []

      # Icon
      if item[:icon]
        content << render_menu_icon(item[:icon])
      end

      # Title
      content << render_menu_title(item[:title], has_children)

      # Arrow (for accordion items)
      if has_children
        content << render_menu_arrow
      end

      content.join.html_safe
    end
  end

  # Render menu icon
  def render_menu_icon(icon_class)
    content_tag(:span, class: 'kt-menu-icon items-start text-muted-foreground w-[20px]') do
      content_tag(:i, '', class: "#{icon_class} text-lg")
    end
  end

  # Render menu title
  def render_menu_title(title, has_children = false)
    title_classes = 'kt-menu-title text-sm font-medium text-foreground'
    title_classes += ' kt-menu-item-active:text-primary kt-menu-link-hover:!text-primary' if has_children

    content_tag(:span, title, class: title_classes)
  end

  # Render menu arrow
  def render_menu_arrow
    content_tag(:span, class: 'kt-menu-arrow text-muted-foreground w-[20px] shrink-0 justify-end ms-1 me-[-10px]') do
      show_icon = content_tag(:span, class: 'inline-flex kt-menu-item-show:hidden') do
        content_tag(:i, '', class: 'ki-filled ki-plus text-[11px]')
      end

      hide_icon = content_tag(:span, class: 'hidden kt-menu-item-show:inline-flex') do
        content_tag(:i, '', class: 'ki-filled ki-minus text-[11px]')
      end

      show_icon + hide_icon
    end
  end

  # Render accordion content
  def render_accordion(children)
    content_tag(:div, class: 'kt-menu-accordion gap-1 ps-[10px] relative before:absolute before:start-[20px] before:top-0 before:bottom-0 before:border-s before:border-border') do
      children.map do |child|
        render_child_item(child)
      end.join.html_safe
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

    content_tag(:div, class: 'kt-menu-item') do
      link_to(child[:url] || '#', class: link_classes, tabindex: 0) do
        bullet = render_menu_bullet
        title = render_child_title(child[:title])

        bullet + title
      end
    end
  end

  # Render nested accordion item
  def render_nested_accordion_item(child)
    content_tag(:div, class: 'kt-menu-item', data: { 'kt-menu-item-toggle' => 'accordion', 'kt-menu-item-trigger' => 'click' }) do
      # Nested link
      nested_link = render_nested_link(child)

      # Nested accordion
      nested_accordion = render_nested_accordion(child[:children])

      nested_link + nested_accordion
    end
  end

  # Render nested link
  def render_nested_link(child)
    content_tag(:div, class: 'kt-menu-link border border-transparent grow cursor-pointer gap-[14px] ps-[10px] pe-[10px] py-[8px]', tabindex: 0) do
      bullet = render_menu_bullet
      title = render_nested_title(child[:title])
      arrow = render_menu_arrow

      bullet + title + arrow
    end
  end

  # Render nested accordion
  def render_nested_accordion(children)
    content_tag(:div, class: 'kt-menu-accordion gap-1 relative before:absolute before:start-[32px] ps-[22px] before:top-0 before:bottom-0 before:border-s before:border-border') do
      children.map do |grandchild|
        render_grandchild_item(grandchild)
      end.join.html_safe
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

    content_tag(:div, class: 'kt-menu-item') do
      link_to(grandchild[:url] || '#', class: link_classes, tabindex: 0) do
        bullet = render_menu_bullet
        title = render_grandchild_title(grandchild[:title])

        bullet + title
      end
    end
  end

  # Render "show more" item
  def render_show_more_item(item)
    content_tag(:div, class: 'kt-menu-item flex-col-reverse', data: { 'kt-menu-item-toggle' => 'accordion', 'kt-menu-item-trigger' => 'click' }) do
      # Show more link
      show_more_link = render_show_more_link(item)

      # Hidden items
      hidden_items = render_hidden_items(item[:children])

      show_more_link + hidden_items
    end
  end

  # Render show more link
  def render_show_more_link(item)
    content_tag(:div, class: 'kt-menu-link border border-transparent grow cursor-pointer gap-[5px] ps-[10px] pe-[10px] py-[8px]', tabindex: 0) do
      bullet = render_menu_bullet
      title = render_show_more_title(item[:title])
      arrow = render_menu_arrow

      bullet + title + arrow
    end
  end

  # Render hidden items
  def render_hidden_items(children)
    content_tag(:div, class: 'kt-menu-accordion gap-1') do
      children.map do |hidden_child|
        render_hidden_item(hidden_child)
      end.join.html_safe
    end
  end

  # Render hidden item
  def render_hidden_item(child)
    link_classes = 'kt-menu-link border border-transparent items-center grow kt-menu-item-active:bg-accent/60 dark:menu-item-active:border-border kt-menu-item-active:rounded-lg hover:bg-accent/60 hover:rounded-lg gap-[5px] ps-[10px] pe-[10px] py-[8px]'

    content_tag(:div, class: 'kt-menu-item') do
      link_to(child[:url] || '#', class: link_classes, tabindex: 0) do
        bullet = render_menu_bullet
        title = render_grandchild_title(child[:title])

        bullet + title
      end
    end
  end

  # Render menu bullet
  def render_menu_bullet
    content_tag(:span, class: 'kt-menu-bullet flex w-[6px] -start-[3px] rtl:start-0 relative before:absolute before:top-0 before:size-[6px] before:rounded-full rtl:before:translate-x-1/2 before:-translate-y-1/2 kt-menu-item-active:before:bg-primary kt-menu-item-hover:before:bg-primary')
  end

  # Render child title
  def render_child_title(title)
    content_tag(:span, title, class: 'kt-menu-title text-2sm font-normal text-foreground kt-menu-item-active:text-primary kt-menu-item-active:font-semibold kt-menu-link-hover:!text-primary')
  end

  # Render nested title
  def render_nested_title(title)
    content_tag(:span, title, class: 'kt-menu-title text-2sm font-normal me-1 text-foreground kt-menu-item-active:text-primary kt-menu-item-active:font-medium kt-menu-link-hover:!text-primary')
  end

  # Render grandchild title
  def render_grandchild_title(title)
    content_tag(:span, title, class: 'kt-menu-title text-2sm font-normal text-foreground kt-menu-item-active:text-primary kt-menu-item-active:font-semibold kt-menu-link-hover:!text-primary')
  end

  # Render show more title
  def render_show_more_title(title)
    content_tag(:span, class: 'kt-menu-title text-2sm font-normal text-secondary-foreground') do
      show_less = content_tag(:span, class: 'hidden kt-menu-item-show:!flex') do
        'Show less'
      end

      show_more = content_tag(:span, class: 'flex kt-menu-item-show:hidden') do
        title
      end

      show_less + show_more
    end
  end

  # Render label item (for "Soon" badges)
  def render_label_item(item)
    content_tag(:div, class: 'kt-menu-item') do
      content_tag(:div, class: 'kt-menu-label border border-transparent gap-[10px] ps-[10px] pe-[10px] py-[6px]', href: item[:url] || '', tabindex: 0) do
        content = []

        # Icon
        if item[:icon]
          content << render_menu_icon(item[:icon])
        end

        # Title
        content << content_tag(:span, item[:title], class: 'kt-menu-title text-sm font-medium text-foreground')

        # Badge
        if item[:badge]
          content << render_badge(item[:badge])
        end

        content.join.html_safe
      end
    end
  end

  # Render badge
  def render_badge(badge_text)
    content_tag(:span, class: 'kt-menu-badge me-[-10px]') do
      content_tag(:span, badge_text, class: 'kt-badge kt-badge-sm text-accent-foreground/60')
    end
  end
end