# app/helpers/dashboard_helper.rb
module KT::DashboardHelper
  # ✅ SRP: menampilkan judul dashboard
  def dashboard_title(title, subtitle)
    content_tag(:div, class: "flex flex-col justify-center gap-2") do
      concat(content_tag(:h1, title, class: "text-xl font-medium leading-none text-mono"))
      concat(content_tag(:div, subtitle, class: "flex items-center gap-2 text-sm font-normal text-secondary-foreground"))
    end
  end

  # ✅ SRP: kartu statistik (LinkedIn, YouTube, dsb)
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

  # ✅ SRP: grup avatar (team, meeting, dsb)
  def team_avatar_group(avatars:, count: nil)
    content_tag(:div, class: "flex -space-x-2") do
      avatars.each do |src|
        concat image_tag(src, class: "hover:z-5 relative shrink-0 rounded-full ring-1 ring-background size-[30px]")
      end
      if count
        concat content_tag(:span, "+#{count}", class: "relative inline-flex items-center justify-center shrink-0 rounded-full ring-1 font-semibold leading-none text-2xs size-[30px] text-white ring-background bg-green-500")
      end
    end
  end

  # ✅ SRP: menampilkan bintang rating (1–5)
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

  # ✅ SRP: badge reusable
  def badge(type:, text:)
    css = "kt-badge kt-badge-outline kt-badge-#{type} kt-badge-sm"
    content_tag(:span, text, class: css)
  end

  # ✅ SRP: tabel reusable
  def datatable_table(headers:, rows:)
    content_tag(:table, class: "kt-table kt-table-border table-fixed") do
      concat(
        content_tag(:thead) do
          content_tag(:tr) do
            safe_join(headers.map { |h| content_tag(:th, h) })
          end
        end
      )
      concat(
        content_tag(:tbody) do
          safe_join(rows.map do |row|
            content_tag(:tr) do
              safe_join(row.map { |cell| content_tag(:td, cell) })
            end
          end)
        end
      )
    end
  end
end
