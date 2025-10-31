# app/helpers/kt/features/dashboard_helper.rb
module KT
  module Features
    module DashboardHelper
        include KT::UI::Base::BaseUIHelper

        # ✅ SRP: Dashboard title with subtitle
        def dashboard_title(title, subtitle)
        content_tag(:div, class: "flex flex-col justify-center gap-2") do
          concat(content_tag(:h1, title, class: "text-xl font-medium leading-none text-mono"))
          concat(content_tag(:div, subtitle, class: "flex items-center gap-2 text-sm font-normal text-secondary-foreground"))
        end
        end

        # ✅ SRP: Statistics card with background
        def stats_card(icon:, title:, value:, bg_class: "channel-stats-bg")
        content_tag(:div, class: "kt-card flex-col justify-between gap-6 h-full bg-cover bg-no-repeat #{bg_class}") do
          concat image_tag(icon, class: "w-7 mt-4 ms-5", alt: "")
          concat(
            content_tag(:div, class: "flex flex-col gap-1 pb-4 px-5") do
              concat content_tag(:span, value, class: "text-3xl font-semibold text-mono")
              concat content_tag(:span, title, class: "text-sm font-normal text-secondary-foreground")
            end
          )
        end
        end

        # ✅ SRP: Team avatar group - using base UI avatar
        def team_avatar_group(avatars:, count: nil)
        content_tag(:div, class: "flex -space-x-2") do
          avatars.each do |src|
            concat ui_avatar(src: src, size: "size-[30px]", avatar_class: "relative shrink-0 rounded-full ring-1 ring-background hover:z-5")
          end
          if count
            concat content_tag(:span, "+#{count}", class: "relative inline-flex items-center justify-center shrink-0 rounded-full ring-1 font-semibold leading-none text-2xs size-[30px] text-white ring-background bg-green-500")
          end
        end
        end

        # ✅ SRP: Rating stars display
        def rating_stars(score)
        safe_join(
          (1..5).map do |i|
            css = i <= score ? "checked" : ""
            content_tag(:div, class: "kt-rating-label #{css}") do
              concat content_tag(:i, "", class: "kt-rating-on ki-solid ki-star text-base leading-none")
              concat content_tag(:i, "", class: "kt-rating-off ki-outline ki-star text-base leading-none")
            end
          end
        )
        end

        # ✅ SRP: Badge - using base UI badge
        def badge(type:, text:)
        ui_badge(text: text, type: type, size: :sm, outline: true)
        end

        # ✅ SRP: Data table - using base UI table
        def datatable_table(headers:, rows:)
        ui_table(headers: headers.map { |h| { title: h } }, rows: rows, table_class: "kt-table kt-table-border table-fixed")
      end
    end
  end
end
