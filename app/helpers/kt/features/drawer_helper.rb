# app/helpers/kt/features/drawer_helper.rb
module KT
  module Features
    module DrawerHelper
      # ===============================
      # 🔹 DRAWER COMPONENTS
      # ===============================

      # ✅ SRP: Generic drawer container
      def drawer_container(id:, position: :end, size: "w-[450px]", max_width: "max-w-[90%]", classes: "", data_attrs: {}, &block)
        default_classes = "hidden kt-drawer kt-drawer-#{position} card flex-col #{max_width} #{size} top-5 bottom-5 end-5 rounded-xl border border-border #{classes}"
        default_data = { "kt-drawer": true, "kt-drawer-container": "body" }.merge(data_attrs)

        content_tag(:div, id: id, class: default_classes, data: default_data, &block)
      end

      # ✅ SRP: Drawer header with title and close button
      def drawer_header(title:, close_data: { "kt-drawer-dismiss": true })
        content_tag(:div, class: "flex items-center justify-between gap-2.5 text-sm text-mono font-semibold px-5 py-3.5 border-b border-b-border") do
          concat title
          concat drawer_close_button(close_data)
        end
      end

      # ✅ SRP: Drawer close button
      def drawer_close_button(data_attrs = { "kt-drawer-dismiss": true })
        button_tag(class: "kt-btn kt-btn-sm kt-btn-icon kt-btn-dim shrink-0", data: data_attrs) do
          content_tag(:i, "", class: "ki-filled ki-cross")
        end
      end

      # ✅ SRP: Drawer body with scrollable content
      def drawer_body(scrollable: true, &block)
        classes = scrollable ? "kt-scrollable-y-auto grow" : "grow"
        data_attrs = scrollable ? { "kt-scrollable": true, "kt-scrollable-dependencies": "#header", "kt-scrollable-max-height": "auto", "kt-scrollable-offset": "150px" } : {}

        content_tag(:div, class: classes, data: data_attrs, &block)
      end

      # ✅ SRP: Drawer footer
      def drawer_footer(classes: "grid p-5 gap-2.5", &block)
        content_tag(:div, class: classes, &block)
      end

      # ✅ SRP: Drawer toggle button
      def drawer_toggle_button(target:, icon:, classes: "kt-btn kt-btn-ghost kt-btn-icon size-9 rounded-full hover:bg-primary/10 hover:[&_i]:text-primary")
        button_tag(class: classes, data: { "kt-drawer-toggle": target }) do
          content_tag(:i, "", class: "ki-filled #{icon} text-lg")
        end
      end
    end
  end
end
