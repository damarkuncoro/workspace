module SidebarHelper
  # ===============================================
  # == ENTRY POINT ==
  # ===============================================
  def render_sidebar(menu_data = default_sidebar_menu)
    content_tag(:div, class: "kt-sidebar-content flex grow shrink-0 py-5 pe-2", id: "sidebar_content") do
      content_tag(:div,
        class: "kt-scrollable-y-hover grow shrink-0 flex ps-2 lg:ps-5 pe-1 lg:pe-3",
        data: scrollable_data_attrs,
        id: "sidebar_scrollable"
      ) do
        content_tag(:div, class: "kt-menu flex flex-col grow gap-1", data: menu_data_attrs, id: "sidebar_menu") do
          safe_join(menu_data.map { |section| build_menu_section(section) })
        end
      end
    end
  end

  # ===============================================
  # == MENU BUILDERS ==
  # ===============================================
  private

  def build_menu_section(section)
    case section[:type]
    when :heading
      sidebar_heading(section[:title])
    when :menu
      sidebar_menu_item(section)
    else
      ""
    end
  end

  def sidebar_heading(title)
    content_tag(:div, class: "kt-menu-item pt-2.25 pb-px") do
      content_tag(:span, title, class: "kt-menu-heading uppercase text-xs font-medium text-muted-foreground ps-[10px] pe-[10px]")
    end
  end

  def sidebar_menu_item(section)
    content_tag(:div, class: "kt-menu-item", data: { kt_menu_item_toggle: "accordion", kt_menu_item_trigger: "click" }) do
      concat sidebar_menu_link(section[:icon], section[:title])
      concat sidebar_menu_children(section[:children]) if section[:children].present?
    end
  end

  def sidebar_menu_link(icon, title)
    content_tag(:div, class: "kt-menu-link flex items-center grow cursor-pointer border border-transparent gap-[10px] ps-[10px] pe-[10px] py-[6px]", tabindex: "0") do
      concat(icon_tag(icon))
      concat(content_tag(:span, title, class: "kt-menu-title text-sm font-medium text-foreground"))
      concat(accordion_arrow)
    end
  end

  def sidebar_menu_children(children)
    content_tag(:div, class: "kt-menu-accordion gap-1 ps-[10px] relative before:absolute before:start-[20px] before:top-0 before:bottom-0 before:border-s before:border-border") do
      safe_join(children.map { |child| build_child_item(child) })
    end
  end

  def build_child_item(item)
    case item[:type]
    when :link
      sidebar_link(item[:title], item[:path])
    when :dropdown
      sidebar_dropdown(item[:title], item[:children])
    else
      ""
    end
  end

  def sidebar_dropdown(title, links)
    content_tag(:div, class: "kt-menu-item", data: { kt_menu_item_toggle: "accordion", kt_menu_item_trigger: "click" }) do
      concat(content_tag(:div, title, class: "kt-menu-link cursor-pointer ps-[10px] pe-[10px] py-[8px] text-sm text-foreground"))
      concat(content_tag(:div, safe_join(links.map { |link| sidebar_link(link[:title], link[:path]) }), class: dropdown_container_classes))
    end
  end

  def sidebar_link(title, path)
    link_to path, class: link_classes do
      concat(content_tag(:span, "", class: bullet_classes))
      concat(content_tag(:span, title, class: title_classes))
    end
  end

  # ===============================================
  # == SMALL HELPERS (SRP: 1 Tugas / Fungsi) ==
  # ===============================================
  def icon_tag(icon)
    return "".html_safe unless icon
    content_tag(:span, content_tag(:i, "", class: "ki-filled #{icon} text-lg"), class: "kt-menu-icon items-start text-muted-foreground w-[20px]")
  end

  def accordion_arrow
    content_tag(:span, class: "kt-menu-arrow text-muted-foreground w-[20px] shrink-0 justify-end ms-1 me-[-10px]") do
      concat(content_tag(:span, content_tag(:i, "", class: "ki-filled ki-plus text-[11px]"), class: "inline-flex kt-menu-item-show:hidden"))
      concat(content_tag(:span, content_tag(:i, "", class: "ki-filled ki-minus text-[11px]"), class: "hidden kt-menu-item-show:inline-flex"))
    end
  end

  def scrollable_data_attrs
    {
      kt_scrollable: true,
      kt_scrollable_dependencies: "#sidebar_header",
      kt_scrollable_height: "auto",
      kt_scrollable_offset: "0px",
      kt_scrollable_wrappers: "#sidebar_content"
    }
  end

  def menu_data_attrs
    { kt_menu: true, kt_menu_accordion_expand_all: false }
  end

  # === CLASS CONSTANTS ===
  def link_classes
    "kt-menu-link border border-transparent items-center grow hover:bg-accent/60 hover:rounded-lg gap-[14px] ps-[10px] pe-[10px] py-[8px]"
  end

  def bullet_classes
    "kt-menu-bullet flex w-[6px] before:absolute before:size-[6px] before:rounded-full before:bg-primary"
  end

  def title_classes
    "kt-menu-title text-2sm font-normal text-foreground"
  end

  def dropdown_container_classes
    "kt-menu-accordion gap-1 relative before:absolute before:start-[32px] ps-[22px] before:top-0 before:bottom-0 before:border-s before:border-border"
  end

  # ===============================================
  # == DEFAULT MENU DATA (SRP: hanya struktur data) ==
  # ===============================================
  def mock_sidebar_menu
    [
      {
        type: :menu,
        title: "Dashboards",
        icon: "ki-element-11",
        children: [
          { type: :link, title: "Light Sidebar", path: "/demo1.html" },
          { type: :link, title: "Dark Sidebar", path: "/demo1/dashboards/dark-sidebar.html" }
        ]
      },
      { type: :heading, title: "User" },
      {
        type: :menu,
        title: "Public Profile",
        icon: "ki-profile-circle",
        children: [
          {
            type: :dropdown,
            title: "Profiles",
            children: [
              { type: :link, title: "Default", path: "/demo1/public-profile/profiles/default.html" },
              { type: :link, title: "Creator", path: "/demo1/public-profile/profiles/creator.html" },
              { type: :link, title: "Company", path: "/demo1/public-profile/profiles/company.html" }
            ]
          },
          { type: :link, title: "Works", path: "/demo1/public-profile/works.html" }
        ]
      },
      {
        type: :menu,
        title: "My Account",
        icon: "ki-setting-2",
        children: [
          {
            type: :dropdown,
            title: "Billing",
            children: [
              { type: :link, title: "Basic", path: "/demo1/account/billing/basic.html" },
              { type: :link, title: "Enterprise", path: "/demo1/account/billing/enterprise.html" }
            ]
          }
        ]
      }
    ]
  end

  def default_sidebar_menu
    [
      {
        type: :menu,
        title: "Dashboard",
        icon: "ki-element-11",
        children: [
          { type: :link, title: "Dashboard", path: protected_dashboard_path }
        ]
      },
      { type: :heading, title: "Management" },
      {
        type: :menu,
        title: "Accounts",
        icon: "ki-profile-circle",
        children: [
          { type: :link, title: "All Accounts", path: protected_accounts_path },
          { type: :link, title: "New Account", path: new_protected_account_path }
        ]
      },
      {
        type: :menu,
        title: "Customers",
        icon: "ki-users",
        children: [
          { type: :link, title: "All Customers", path: protected_customers_path },
          { type: :link, title: "New Customer", path: new_protected_customer_path }
        ]
      },
      {
        type: :menu,
        title: "Employees",
        icon: "ki-user",
        children: [
          { type: :link, title: "All Employees", path: protected_employees_path },
          { type: :link, title: "New Employee", path: new_protected_employee_path }
        ]
      },
      {
        type: :menu,
        title: "Issues",
        icon: "ki-message-text",
        children: [
          { type: :link, title: "All Issues", path: protected_issues_path },
          { type: :link, title: "Customer Issues", path: protected_issues_customers_path },
          { type: :link, title: "Employee Issues", path: protected_issues_employees_path }
        ]
      },
      { type: :heading, title: "Settings" },
      {
        type: :menu,
        title: "Profile",
        icon: "ki-setting-2",
        children: [
          { type: :link, title: "View Profile", path: protected_profile_show_path },
          { type: :link, title: "Edit Profile", path: protected_profile_edit_path }
        ]
      },
      {
        type: :menu,
        title: "Roles",
        icon: "ki-shield-tick",
        children: [
          { type: :link, title: "View Roles", path: protected_roles_show_path },
          { type: :link, title: "Edit Roles", path: protected_roles_edit_path }
        ]
      }
    ]
  end


end
