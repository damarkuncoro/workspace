module KT::Profile::BadgesHelper
  include KT::Card::CardHelper
  include KT::Card::HeaderHelper
  include KT::Card::BodyHelper
  include KT::Card::FooterHelper

  # Menampilkan kartu "Community Badges"
  # Dapat menerima array custom badges, atau gunakan default jika tidak diberikan
  def community_badges_card(custom_badges = nil)
    full_card(title: "Community Badges") do
      card_body_flex(
        direction: "flex-row",
        justify: "start",
        items: "center",
        gap: "gap-3 lg:gap-4",
        padding: "pb-7.5"
      ) do
        safe_join((custom_badges || default_badges).map { |badge| badge_svg(*badge) })
      end
    end
  end

  # Badges Card for Profile
  def badges_card
    full_card(title: "Badges", header_actions: badges_header_actions) do
      card_body(padding: "pb-7.5") do
        content_tag(:div, class: "grid gap-2.5") do
          safe_join(default_badge_items)
        end
      end
    end
  end

  private

  # Daftar default badges (kelas warna, ikon, warna ikon)
  def default_badges
    [
      ["stroke-primary/10 fill-primary/5", "ki-abstract-39", "text-primary"],
      ["stroke-yellow-200 dark:stroke-yellow-950 fill-yellow-100 dark:fill-yellow-950/30", "ki-abstract-44", "text-yellow-600"],
      ["stroke-green-200 dark:stroke-green-950 fill-green-100 dark:fill-green-950/30", "ki-abstract-25", "text-green-600"],
      ["stroke-violet-200 dark:stroke-violet-950 fill-violet-100 dark:fill-violet-950/30", "ki-delivery-24", "text-violet-600"]
    ]
  end

  # Membuat elemen SVG untuk setiap badge
  def badge_svg(stroke_fill_classes, icon, icon_color)
    content_tag(:div, class: "relative size-[50px] shrink-0") do
      concat hexagon_svg(stroke_fill_classes)
      concat icon_overlay(icon, icon_color)
    end
  end

  # SVG bentuk heksagon untuk badge
  def hexagon_svg(stroke_fill_classes)
    content_tag(:svg,
      class: "w-full h-full #{stroke_fill_classes}",
      fill: "none",
      height: "48",
      viewBox: "0 0 44 48",
      width: "44",
      xmlns: "http://www.w3.org/2000/svg"
    ) do
      concat(tag.path(d: hexagon_path_fill, fill: ""))
      concat(tag.path(d: hexagon_path_stroke, stroke: ""))
    end
  end

  # Ikon di tengah badge
  def icon_overlay(icon, icon_color)
    content_tag(:div, class: "absolute leading-none start-2/4 top-2/4 -translate-y-2/4 -translate-x-2/4 rtl:translate-x-2/4") do
      content_tag(:i, "", class: "ki-filled #{icon} text-xl ps-px #{icon_color}")
    end
  end

  # Path bentuk hexagon isi
  def hexagon_path_fill
    "M16 2.4641C19.7128 0.320509 24.2872 0.320508 28 2.4641L37.6506 8.0359C41.3634 10.1795 43.6506 14.141 43.6506
    18.4282V29.5718C43.6506 33.859 41.3634 37.8205 37.6506 39.9641L28 45.5359C24.2872 47.6795 19.7128 47.6795 16 45.5359L6.34937
    39.9641C2.63655 37.8205 0.349365 33.859 0.349365 29.5718V18.4282C0.349365 14.141 2.63655 10.1795 6.34937 8.0359L16 2.4641Z"
  end

  # Path bentuk hexagon garis tepi
  def hexagon_path_stroke
    "M16.25 2.89711C19.8081 0.842838 24.1919 0.842837 27.75 2.89711L37.4006 8.46891C40.9587 10.5232 43.1506 14.3196 43.1506
    18.4282V29.5718C43.1506 33.6804 40.9587 37.4768 37.4006 39.5311L27.75 45.1029C24.1919 47.1572 19.8081 47.1572 16.25 45.1029L6.59937
    39.5311C3.04125 37.4768 0.849365 33.6803 0.849365 29.5718V18.4282C0.849365 14.3196 3.04125 10.5232 6.59937 8.46891L16.25 2.89711Z"
  end

  private

  def default_badge_items
    [
      badge_item("Expert Contributor Badge", "stroke-primary/10 fill-primary/5", "ki-abstract-39", "text-primary"),
      badge_item("Innovation Trailblazer", "stroke-yellow-200 dark:stroke-yellow-950 fill-yellow-100 dark:fill-yellow-950/30", "ki-abstract-44", "text-yellow-600"),
      badge_item("Impact Recognition", "stroke-green-200 dark:stroke-green-950 fill-green-100 dark:fill-green-950/30", "ki-abstract-25", "text-green-600"),
      badge_item("Performance Honor", "stroke-violet-200 dark:stroke-violet-950 fill-violet-100 dark:fill-violet-950/30", "ki-delivery-24", "text-violet-600")
    ]
  end

  def badge_item(title, stroke_fill_classes, icon, icon_color)
    content_tag(:div, class: "flex items-center justify-between flex-wrap group border border-border rounded-xl gap-2 px-3.5 py-2.5") do
      concat(content_tag(:div, class: "flex items-center flex-wrap gap-2.5") do
        concat(badge_svg(stroke_fill_classes, icon, icon_color))
        concat(content_tag(:span, title, class: "text-mono text-sm font-medium"))
      end)
      concat(content_tag(:div, class: "kt-btn kt-btn-sm kt-btn-icon bg-transparent text-muted-foreground/60 group-hover:text-primary") do
        tag.svg(class: "size-6", fill: "none", viewBox: "0 0 24 24", xmlns: "http://www.w3.org/2000/svg") do
          tag.rect(fill: "currentColor", height: "3", rx: "1.5", width: "18", x: "3", y: "14.5")
          tag.rect(fill: "currentColor", height: "3", rx: "1.5", width: "18", x: "3", y: "6.5")
        end
      end)
    end
  end

  private

  def badges_header_actions
    content_tag(:div, class: "kt-menu", "data-kt-menu": "true") do
      content_tag(:div, class: "kt-menu-item kt-menu-item-dropdown", "data-kt-menu-item-offset": "0, 10px", "data-kt-menu-item-placement": "bottom-end", "data-kt-menu-item-placement-rtl": "bottom-start", "data-kt-menu-item-toggle": "dropdown", "data-kt-menu-item-trigger": "click") do
        concat(content_tag(:button, class: "kt-menu-toggle kt-btn kt-btn-icon kt-btn-ghost") do
          tag.i("", class: "ki-filled ki-information-2")
        end)
        concat(content_tag(:div, class: "kt-menu-dropdown kt-menu-default w-full max-w-[175px]", "data-kt-menu-dismiss": "true") do
          safe_join([
            content_tag(:div, class: "kt-menu-item") do
              content_tag(:a, href: "/metronic/tailwind/demo1/account/home/settings-plain", class: "kt-menu-link") do
                safe_join([
                  content_tag(:span, class: "kt-menu-icon") do
                    tag.i("", class: "ki-filled ki-add-files")
                  end,
                  content_tag(:span, "Add", class: "kt-menu-title")
                ])
              end
            end,
            content_tag(:div, class: "kt-menu-item") do
              content_tag(:a, href: "/metronic/tailwind/demo1/account/members/import-members", class: "kt-menu-link") do
                safe_join([
                  content_tag(:span, class: "kt-menu-icon") do
                    tag.i("", class: "ki-filled ki-file-down")
                  end,
                  content_tag(:span, "Import", class: "kt-menu-title")
                ])
              end
            end,
            content_tag(:div, class: "kt-menu-item kt-menu-item-dropdown", "data-kt-menu-item-offset": "-15px, 0", "data-kt-menu-item-placement": "right-start", "data-kt-menu-item-toggle": "dropdown", "data-kt-menu-item-trigger": "click|lg:hover") do
              safe_join([
                content_tag(:div, class: "kt-menu-link") do
                  safe_join([
                    content_tag(:span, class: "kt-menu-icon") do
                      tag.i("", class: "ki-filled ki-file-up")
                    end,
                    content_tag(:span, "Export", class: "kt-menu-title"),
                    content_tag(:span, class: "kt-menu-arrow") do
                      tag.i("", class: "ki-filled ki-right text-xs rtl:transform rtl:rotate-180")
                    end
                  ])
                end,
                content_tag(:div, class: "kt-menu-dropdown kt-menu-default w-full max-w-[125px]") do
                  safe_join([
                    content_tag(:div, class: "kt-menu-item") do
                      content_tag(:a, href: "/metronic/tailwind/demo1/account/home/settings-sidebar", class: "kt-menu-link") do
                        content_tag(:span, "PDF", class: "kt-menu-title")
                      end
                    end,
                    content_tag(:div, class: "kt-menu-item") do
                      content_tag(:a, href: "/metronic/tailwind/demo1/account/home/settings-sidebar", class: "kt-menu-link") do
                        content_tag(:span, "CVS", class: "kt-menu-title")
                      end
                    end,
                    content_tag(:div, class: "kt-menu-item") do
                      content_tag(:a, href: "/metronic/tailwind/demo1/account/home/settings-sidebar", class: "kt-menu-link") do
                        content_tag(:span, "Excel", class: "kt-menu-title")
                      end
                    end
                  ])
                end
              ])
            end,
            content_tag(:div, class: "kt-menu-item") do
              content_tag(:a, href: "/metronic/tailwind/demo1/account/security/privacy-settings", class: "kt-menu-link") do
                safe_join([
                  content_tag(:span, class: "kt-menu-icon") do
                    tag.i("", class: "ki-filled ki-setting-3")
                  end,
                  content_tag(:span, "Settings", class: "kt-menu-title")
                ])
              end
            end
          ])
        end)
      end
    end
  end
end
