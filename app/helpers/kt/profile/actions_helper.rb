module KT::Profile::ActionsHelper
  include KT::Card::CardHelper
  include KT::Card::HeaderHelper
  include KT::Card::BodyHelper
  include KT::Card::FooterHelper

  # 🔹 Profile Actions (bisa dikustomisasi lewat parameter)
  def profile_actions(actions = default_actions)
    content_tag(:div, class: "flex flex-wrap gap-2") do
      safe_join(actions.map { |label, path, style| link_to(label, path, class: "btn #{style}") })
    end
  end

  # ==========================================================
  # 🔹 UTAMA: Profile Header Section
  # ==========================================================
  def profile_header_section(title: "User Profile", description: "Central Hub for Personal Customization", actions: default_header_actions)
    card_header_flex(justify: "between", items: "center", gap: "gap-5 pb-7.5") do
      concat(profile_header_title_section(title: title, description: description))
      concat(profile_header_actions_section(actions: actions))
    end
  end

  # ==========================================================
  # 🔹 UTAMA: Complete Profile Show Page
  # ==========================================================
  def profile_show_page(
    title: "User Profile",
    description: "Central Hub for Personal Customization",
    actions: default_header_actions,
    cards_layout: :single_column,
    person: nil,
    customer: nil,
    employee: nil
  )
    container(columns: 1) do
      concat(profile_header_section(title: title, description: description, actions: actions))
      concat(profile_content_section(cards_layout: cards_layout, person: person, customer: customer, employee: employee))
    end
  end

  private

  def profile_content_section(cards_layout: :single_column, person: nil, customer: nil, employee: nil)
    case cards_layout
    when :single_column
      single_column_layout(person: person, customer: customer, employee: employee)
    when :two_columns
      two_columns_layout(person: person, customer: customer, employee: employee)
    else
      single_column_layout(person: person, customer: customer, employee: employee)
    end
  end

  def single_column_layout(person: nil, customer: nil, employee: nil)
    content_tag(:div, class: "col-span-1") do
      content_tag(:div, class: "grid gap-5 lg:gap-7.5") do
        safe_join([
          personal_info_card(person: person),
          basic_settings_card,
          work_card,
          badges_card
        ])
      end
    end
  end

  def two_columns_layout(person: nil, customer: nil, employee: nil)
    content_tag(:div, class: "col-span-1") do
      content_tag(:div, class: "grid grid-cols-1 md:grid-cols-2 gap-5 lg:gap-7.5") do
        safe_join([
          personal_info_card(person: person),
          basic_settings_card,
          work_card,
          badges_card
        ])
      end
    end
  end
   # ==========================================================
  # 🔹 PROFILE ACTIONS
  # ==========================================================
  def profile_actions(actions = default_actions)
    content_tag(:div, class: "flex flex-wrap gap-2") do
      safe_join(actions.map { |label, path, style| link_to(label, path, class: "btn #{style}") })
    end
  end




  private



  # ✅ Default tombol pada profile actions
  def default_actions
    [
      ["Edit Profile", protected_profile_edit_path, "btn-primary"],
      ["Back to Dashboard", protected_dashboard_path, "btn-secondary"]
    ]
  end

  # ✅ Default tombol pada header section
  def default_header_actions
    [
      ["Public Profile", "#", "kt-btn kt-btn-outline"],
      ["Account Settings", "#", "kt-btn kt-btn-primary"]
    ]
  end


 # ==========================================================
 # ✅ Header Title + Description
 # ==========================================================
 def profile_header_title_section(title:, description:)
   content_tag(:div, class: "flex flex-col justify-center gap-2") do
     concat(content_tag(:h1, title, class: "text-xl font-medium leading-none text-mono"))
     concat(content_tag(:div, description, class: "flex items-center gap-2 text-sm font-normal text-secondary-foreground"))
   end
 end

 # ==========================================================
 # ✅ Header Actions
 # ==========================================================
 def profile_header_actions_section(actions:)
   content_tag(:div, class: "flex items-center gap-2.5") do
     safe_join(actions.map { |label, path, style| link_to(label, path, class: "kt-btn #{style}") })
   end
 end


end
