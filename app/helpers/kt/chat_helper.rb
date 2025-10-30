# app/helpers/chat_helper.rb
module KT::ChatHelper
  # ===============================
  # 1️⃣ Tombol Chat Toggle
  # ===============================
  def chat_toggle_button(target: "#chat_drawer")
    button_tag(class: "kt-btn kt-btn-ghost kt-btn-icon size-9 rounded-full hover:bg-primary/10 hover:[&_i]:text-primary",
               data: { "kt-drawer-toggle": target }) do
      content_tag(:i, "", class: "ki-filled ki-messages text-lg")
    end
  end

  # ===============================
  # 2️⃣ Drawer Utama
  # ===============================
  def chat_drawer(chat:)
    content_tag(:div,
                id: "chat_drawer",
                class: "hidden kt-drawer kt-drawer-end card flex-col max-w-[90%] w-[450px] top-5 bottom-5 end-5 rounded-xl border border-border",
                data: { "kt-drawer": true, "kt-drawer-container": "body" }) do
      concat chat_header(chat[:header])
      concat chat_messages(chat[:messages])
      concat chat_footer(chat[:footer])
    end
  end

  # ===============================
  # 3️⃣ Header Chat
  # ===============================
  def chat_header(header)
    content_tag(:div) do
      concat(content_tag(:div, class: "flex items-center justify-between gap-2.5 text-sm text-mono font-semibold px-5 py-3.5") do
        concat "Chat"
        concat(button_tag(class: "kt-btn kt-btn-sm kt-btn-icon kt-btn-dim shrink-0", data: { "kt-drawer-dismiss": true }) do
          content_tag(:i, "", class: "ki-filled ki-cross")
        end)
      end)

      concat content_tag(:div, "", class: "border-b border-b-border")

      concat(content_tag(:div, class: "border-b border-border py-2.5") do
        content_tag(:div, class: "flex items-center justify-between flex-wrap gap-2 px-5") do
          concat chat_header_team_info(header[:team])
          concat chat_header_members(header[:members])
        end
      end)
    end
  end

  def chat_header_team_info(team)
    content_tag(:div, class: "flex items-center flex-wrap gap-2") do
      concat(
        content_tag(:div, class: "flex items-center justify-center shrink-0 rounded-full bg-accent/60 border border-border size-11") do
          image_tag(team[:logo], alt: "", class: "size-7")
        end
      )
      concat(
        content_tag(:div, class: "flex flex-col") do
          concat(link_to(team[:name], "#", class: "text-sm font-semibold text-mono hover:text-primary"))
          concat(content_tag(:span, team[:status], class: "text-xs font-medium italic text-muted-foreground"))
        end
      )
    end
  end

  def chat_header_members(members)
    content_tag(:div, class: "flex items-center gap-2.5") do
      concat team_avatar_group(avatars: members[:avatars], count: members[:count])
      concat chat_menu_dropdown(members[:menu])
    end
  end

  # Reuse dari DashboardHelper
  def team_avatar_group(avatars:, count: nil)
    content_tag(:div, class: "flex -space-x-2") do
      avatars.each do |src|
        concat image_tag(src, class: "hover:z-5 relative shrink-0 rounded-full ring-1 ring-background size-[30px]")
      end
      if count
        concat content_tag(:span, "+#{count}", class: "hover:z-5 relative inline-flex items-center justify-center shrink-0 rounded-full ring-1 font-semibold leading-none text-2xs size-[30px] text-white ring-background bg-green-500")
      end
    end
  end

  # Dropdown Menu
  def chat_menu_dropdown(menu)
    content_tag(:div, class: "kt-menu", data: { "kt-menu": true }) do
      content_tag(:div, class: "kt-menu-item", data: { "kt-menu-item-toggle": "dropdown", "kt-menu-item-trigger": "click|lg:hover" }) do
        concat(button_tag(class: "kt-menu-toggle kt-btn kt-btn-sm kt-btn-icon kt-btn-ghost") do
          content_tag(:i, "", class: "ki-filled ki-dots-vertical text-lg")
        end)
        concat(
          content_tag(:div, class: "kt-menu-dropdown kt-menu-default w-full max-w-[175px]", data: { "kt-menu-dismiss": true }) do
            safe_join(menu.map { |item| chat_menu_item(item) })
          end
        )
      end
    end
  end

  def chat_menu_item(item)
    content_tag(:div, class: "kt-menu-item") do
      link_to(item[:href], class: "kt-menu-link") do
        concat(content_tag(:span, content_tag(:i, "", class: "ki-filled #{item[:icon]}"), class: "kt-menu-icon"))
        concat(content_tag(:span, item[:title], class: "kt-menu-title"))
      end
    end
  end

  # ===============================
  # 4️⃣ Pesan Chat
  # ===============================
  def chat_messages(messages)
    content_tag(:div, class: "kt-scrollable-y-auto grow", data: { "kt-scrollable": true, "kt-scrollable-dependencies": "#header", "kt-scrollable-max-height": "auto", "kt-scrollable-offset": "230px" }) do
      content_tag(:div, class: "flex flex-col gap-5 py-5") do
        safe_join(messages.map { |msg| chat_message(msg) })
      end
    end
  end

  def chat_message(msg)
    side_class = msg[:from_me] ? "justify-end" : ""
    content_tag(:div, class: "flex items-end #{side_class} gap-3.5 px-5") do
      if msg[:from_me]
        concat(chat_bubble(msg, mine: true))
        concat(chat_avatar(msg[:avatar]))
      else
        concat(image_tag(msg[:avatar], class: "rounded-full size-9"))
        concat(chat_bubble(msg))
      end
    end
  end

  def chat_bubble(msg, mine: false)
    wrapper_class = mine ? "flex flex-col gap-1.5 text-right" : "flex flex-col gap-1.5"
    bubble_class = "kt-card shadow-none flex flex-col #{mine ? 'bg-primary text-primary-foreground rounded-be-none' : 'bg-accent/60 text-foreground rounded-bs-none'} gap-2.5 p-3 text-2sm"

    content_tag(:div, class: wrapper_class) do
      concat(content_tag(:div, msg[:text], class: bubble_class))
      concat(content_tag(:span, msg[:time], class: "text-xs font-medium text-muted-foreground"))
    end
  end

  def chat_avatar(src)
    content_tag(:div, class: "relative shrink-0") do
      content_tag(:div, class: "kt-avatar size-9") do
        concat(content_tag(:div, image_tag(src, alt: "avatar"), class: "kt-avatar-image"))
        concat(content_tag(:div, class: "kt-avatar-indicator -end-2 -bottom-2") do
          content_tag(:div, "", class: "kt-avatar-status kt-avatar-status-online size-2.5")
        end)
      end
    end
  end

  # ===============================
  # 5️⃣ Footer Chat
  # ===============================
  def chat_footer(footer)
    content_tag(:div, class: "mb-2.5") do
      concat chat_join_request(footer[:join_request]) if footer[:join_request]
      concat chat_input_box(footer[:input])
    end
  end

  def chat_join_request(request)
    content_tag(:div, class: "flex grow gap-2 px-5 py-3.5 bg-accent/60 mb-2.5 border-y border-border", id: "join_request") do
      concat chat_avatar(request[:avatar])
      concat(
        content_tag(:div, class: "flex items-center justify-between gap-3 grow") do
          concat(content_tag(:div, class: "flex flex-col") do
            concat(content_tag(:div, class: "text-sm mb-px") do
              concat(link_to(request[:name], "#", class: "hover:text-primary font-semibold text-mono"))
              concat(content_tag(:span, " wants to join chat", class: "text-secondary-foreground"))
            end)
            concat(content_tag(:span, "#{request[:time]} · #{request[:team]}", class: "flex items-center text-xs font-medium text-muted-foreground"))
          end)
          concat(content_tag(:div, class: "flex gap-2.5") do
            concat(button_tag("Decline", class: "kt-btn kt-btn-sm kt-btn-outline", data: { "kt-dismiss": "#join_request" }))
            concat(button_tag("Accept", class: "kt-btn kt-btn-sm kt-btn-mono"))
          end)
        end
      )
    end
  end

  def chat_input_box(input)
    content_tag(:div, class: "relative grow mx-5") do
      concat(image_tag(input[:avatar], class: "rounded-full size-[30px] absolute start-0 top-2/4 -translate-y-2/4 ms-2.5", alt: ""))
      concat(text_field_tag(:message, nil, placeholder: "Write a message...", class: "kt-input h-auto py-4 ps-12 bg-transparent"))
      concat(content_tag(:div, class: "flex items-center gap-2.5 absolute end-3 top-1/2 -translate-y-1/2") do
        concat(button_tag(class: "kt-btn kt-btn-sm kt-btn-icon kt-btn-ghost") do
          content_tag(:i, "", class: "ki-filled ki-exit-up")
        end)
        concat(link_to("Send", "#", class: "kt-btn kt-btn-mono kt-btn-sm"))
      end)
    end
  end
end
