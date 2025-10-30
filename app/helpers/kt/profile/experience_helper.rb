module KT::Profile::ExperienceHelper
  # Work Experience Card
  def work_experience_card(experiences: [])
    content_tag(:div, class: "kt-card") do
      concat(content_tag(:div, class: "kt-card-header") do
        content_tag(:h3, "Work Experience", class: "kt-card-title")
      end)
      concat(content_tag(:div, class: "kt-card-content") do
        content_tag(:div, class: "grid gap-y-5") do
          safe_join([
            experience_item(
              logo: "/assets/media/brand-logos/jira.svg",
              company: "Esprito Studios",
              position: "Senior Project Manager",
              period: "2019 - Present"
            ),
            content_tag(:div, "Previous Jobs", class: "text-secondary-foreground font-semibold text-sm leading-none"),
            experience_item(
              logo: "/assets/media/brand-logos/weave.svg",
              company: "Pesto Plus",
              position: "CRM Product Lead",
              period: "2012 - 2019"
            ),
            experience_item(
              logo: "/assets/media/brand-logos/perrier.svg",
              company: "Perrier Technologies",
              position: "UX Research",
              period: "2010 - 2012"
            )
          ])
        end
      end)
      concat(content_tag(:div, class: "kt-card-footer justify-center") do
        link_to("Open to Work", "/demo1/public-profile/works.html", class: "kt-link kt-link-underlined kt-link-dashed")
      end)
    end
  end

  private

  def experience_item(logo:, company:, position:, period:)
    content_tag(:div, class: "flex align-start gap-3.5") do
      concat(image_tag(logo, alt: "", class: "h-9"))
      concat(content_tag(:div, class: "flex flex-col gap-1") do
        concat(link_to(company, "#", class: "text-sm font-medium text-primary leading-none hover:text-primary"))
        concat(content_tag(:span, position, class: "text-sm font-medium text-mono"))
        concat(content_tag(:span, period, class: "text-xs text-secondary-foreground leading-none"))
      end)
    end
  end
end