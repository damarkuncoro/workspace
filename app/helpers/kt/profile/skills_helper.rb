module KT::Profile::SkillsHelper
  # Skills Card
  def skills_card(skills: [])
    content_tag(:div, class: "kt-card") do
      concat(content_tag(:div, class: "kt-card-header") do
        content_tag(:h3, "Skills", class: "kt-card-title")
      end)
      concat(content_tag(:div, class: "kt-card-content") do
        content_tag(:div, class: "flex flex-wrap gap-2.5 mb-2") do
          safe_join([
            skill_badge("Web Design"),
            skill_badge("Code Review"),
            skill_badge("Figma"),
            skill_badge("Product Development"),
            skill_badge("Webflow"),
            skill_badge("AI"),
            skill_badge("noCode"),
            skill_badge("Management")
          ])
        end
      end)
    end
  end

  private

  def skill_badge(skill)
    content_tag(:span, skill, class: "kt-badge kt-badge-outline")
  end
end