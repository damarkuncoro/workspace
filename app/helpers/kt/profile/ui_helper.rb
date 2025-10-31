module KT::Profile::UiHelper
  # ==========================================================
  # 🔹 Badge Builder
  # ==========================================================
  def build_badges(items)
    content_tag(:div, class: "flex flex-wrap gap-2.5") do
      safe_join(items.map { |text| content_tag(:span, text, class: "kt-badge kt-badge-outline") })
    end
  end

  # ==========================================================
  # 🔹 Icon List Builder
  # ==========================================================
  def build_icons(icons)
    content_tag(:div, class: "flex gap-2") do
      safe_join(icons.map do |icon|
        link_to(icon[:url], class: "inline-flex items-center justify-center w-8 h-8 rounded-full border hover:bg-secondary/10") do
          content_tag(:i, "", class: "fa fa-#{icon[:name]}")
        end
      end)
    end
  end
end
