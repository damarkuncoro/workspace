module KT
  module FooterHelper
    # Helper untuk membuat footer
    #
    # @param year [Integer] Tahun copyright, default sekarang
    # @param company [Hash] { name: "Keenthemes Inc.", url: "https://keenthemes.com" }
    # @param links [Array<Hash>] Daftar link footer [{title: "Docs", url: "https://..."}, ...]
    #
    # @example
    #   <%= kt_footer %>
    #   <%= kt_footer(year: 2025, company: {name: "My Company", url: "/"}) %>
    #
    def kt_footer(year: Time.current.year, company: { name: "Keenthemes Inc.", url: "https://keenthemes.com" }, links: nil)
      links ||= [
        { title: "Docs", url: "https://keenthemes.com/metronic/tailwind/docs" },
        { title: "Purchase", url: "https://1.envato.market/Vm7VRE" },
        { title: "FAQ", url: "https://keenthemes.com/metronic/tailwind/docs/getting-started/license" },
        { title: "Support", url: "https://devs.keenthemes.com" },
        { title: "License", url: "https://keenthemes.com/metronic/tailwind/docs/getting-started/license" }
      ]

      content_tag :footer, class: "kt-footer" do
        content_tag :div, class: "kt-container-fixed" do
          content_tag :div, class: "flex flex-col md:flex-row justify-center md:justify-between items-center gap-3 py-5" do
            safe_join([
              # Copyright & Company
              content_tag(:div, class: "flex order-2 md:order-1 gap-2 font-normal text-sm") do
                safe_join([
                  content_tag(:span, "#{year}©", class: "text-secondary-foreground"),
                  link_to(company[:name], company[:url], class: "text-secondary-foreground hover:text-primary")
                ])
              end,
              # Footer links
              content_tag(:nav, class: "flex order-1 md:order-2 gap-4 font-normal text-sm text-secondary-foreground") do
                safe_join(links.map { |link| link_to(link[:title], link[:url], class: "hover:text-primary") })
              end
            ])
          end
        end
      end
    end
  end
end
