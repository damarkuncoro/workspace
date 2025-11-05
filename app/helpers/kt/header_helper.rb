module KT
  module HeaderHelper
    # Main helper: kt_header
    #
    # options:
    #   :logo_src => path logo
    #   :logo_link => link logo
    #   :drawer_buttons => array tombol drawer [{target:, icon_class:}, ...]
    #   :mega_menu_partial => partial path untuk megamenu
    #   :topbar_partial => partial path untuk topbar
    def kt_header(
      logo_src: "/assets/media/app/mini-logo.svg",
      logo_link: "/demo1.html",
      drawer_buttons: default_drawer_buttons,
      mega_menu_partial: "metronic/layouts/partials/page/main/kt-header/megamenu",
      topbar_partial: "metronic/layouts/partials/page/main/kt-header/topbar"
    )
      content_tag(:header, header_attributes) do
        content_tag(:div, container_attributes) do
          concat(render_logo_and_mobile_buttons(logo_src, logo_link, drawer_buttons))
          concat(render_mega_menu_container(mega_menu_partial))
          concat(render_topbar(topbar_partial))
        end
      end
    end

    private

    def default_drawer_buttons
      [
        { target: "#sidebar", icon_class: "ki-filled ki-menu" },
        { target: "#mega_menu_wrapper", icon_class: "ki-filled ki-burger-menu-2" }
      ]
    end

    def header_attributes
      {
        class: "kt-header fixed top-0 z-10 start-0 end-0 flex items-stretch shrink-0 bg-background",
        data: {
          kt_sticky: "true",
          kt_sticky_class: "border-b border-border",
          kt_sticky_name: "header"
        },
        id: "header"
      }
    end

    def container_attributes
      { class: "kt-container-fixed flex justify-between items-stretch lg:gap-4", id: "headerContainer" }
    end

    def render_logo_and_mobile_buttons(logo_src, logo_link, drawer_buttons)
      content_tag(:div, class: "flex gap-2.5 lg:hidden items-center -ms-1") do
        concat(
          link_to(logo_link, class: "shrink-0") do
            image_tag(logo_src, class: "max-h-[25px] w-full")
          end
        )
        concat(render_mobile_buttons(drawer_buttons))
      end
    end

    def render_mobile_buttons(drawer_buttons)
      content_tag(:div, class: "flex items-center") do
        drawer_buttons.each do |btn|
          concat(drawer_button(btn[:target], btn[:icon_class]))
        end
      end
    end

    def drawer_button(target, icon_class)
      button_tag(type: "button", class: "kt-btn kt-btn-icon kt-btn-ghost", data: { kt_drawer_toggle: target }) do
        content_tag(:i, "", class: icon_class)
      end
    end

    def render_mega_menu_container(partial_path)
      content_tag(:div, class: "flex items-stretch", id: "megaMenuContainer") do
        render partial_path
      end
    end

    def render_topbar(partial_path)
      render partial_path
    end
  end
end
