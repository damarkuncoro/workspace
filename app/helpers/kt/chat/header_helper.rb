module KT
  module Chat
    module HeaderHelper
      private

      # Header section
      def chat_header_section(header)
        content_tag(:div) do
          concat chat_title_bar
          concat chat_team_section(header[:team], header[:members])
        end
      end

      # Title bar component
      def chat_title_bar
        content_tag(:div, class: "flex items-center justify-between gap-2.5 text-sm text-mono font-semibold px-5 py-3.5") do
          concat "Chat"
          concat(button_tag(class: "kt-btn kt-btn-sm kt-btn-icon kt-btn-dim shrink-0", data: { "kt-drawer-dismiss": true }) do
            content_tag(:i, "", class: "ki-filled ki-cross")
          end)
        end
      end

      # Team section component
      def chat_team_section(team, members)
        content_tag(:div, "", class: "border-b border-b-border") +
        content_tag(:div, class: "border-b border-border py-2.5") do
          content_tag(:div, class: "flex items-center justify-between flex-wrap gap-2 px-5") do
            concat chat_team_info_component(team)
            concat chat_members_component(members)
          end
        end
      end

      # Team info component
      def chat_team_info_component(team)
        content_tag(:div, class: "flex items-center flex-wrap gap-2") do
          concat chat_team_logo(team[:logo])
          concat chat_team_details(team)
        end
      end

      # Team logo
      def chat_team_logo(logo)
        content_tag(:div, class: "flex items-center justify-center shrink-0 rounded-full bg-accent/60 border border-border size-11") do
          image_tag(logo, alt: "", class: "size-7")
        end
      end

      # Team details
      def chat_team_details(team)
        content_tag(:div, class: "flex flex-col") do
          concat(link_to(team[:name], "#", class: "text-sm font-semibold text-mono hover:text-primary"))
          concat(content_tag(:span, team[:status], class: "text-xs font-medium italic text-muted-foreground"))
        end
      end

      # Members component
      def chat_members_component(members)
        content_tag(:div, class: "flex items-center gap-2.5") do
          concat team_avatars_group(members[:avatars], members[:count])
          concat chat_menu_component(members[:menu])
        end
      end

      # Team avatars group (DRY - reuse from dashboard)
      def team_avatars_group(avatars, count = nil)
        content_tag(:div, class: "flex -space-x-2") do
          avatars.each do |src|
            concat image_tag(src, class: "hover:z-5 relative shrink-0 rounded-full ring-1 ring-background size-[30px]")
          end
          if count
            concat content_tag(:span, "+#{count}", class: "hover:z-5 relative inline-flex items-center justify-center shrink-0 rounded-full ring-1 font-semibold leading-none text-2xs size-[30px] text-white ring-background bg-green-500")
          end
        end
      end
    end
  end
end
