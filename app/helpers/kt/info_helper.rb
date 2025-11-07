module KT
  module InfoHelper
    # kt_info_row: komponen baris label–nilai yang konsisten
    #
    # Parameters:
    # - label: [String] teks label di sisi kiri
    # - value: [String, Proc] teks nilai di sisi kanan; bisa diberikan via block
    # - class_name: [String] tambahan class di wrapper
    # - label_class: [String] override class label
    # - value_class: [String] override class value
    # - bg_class: [String] class background (default accent/50)
    # - padding: [String] class padding (default "py-3 px-4")
    # - rounded: [Boolean] gunakan rounded-lg
    # - tag: [Symbol] tag wrapper (default :div)
    #
    # Contoh:
    # <%= kt_info_row(label: "Email", value: @account.email) %>
    # <%= kt_info_row(label: "Status") do %>
    #   <span class="kt-badge kt-badge-success">active</span>
    # <% end %>
    def kt_info_row(label:, value: nil, **args, &block)
      options = {
        class_name: "",
        label_class: "text-sm font-medium text-secondary-foreground",
        value_class: "text-sm text-foreground",
        bg_class: "bg-accent/50",
        padding: "py-3 px-4",
        rounded: true,
        tag: :div
      }.merge(args)

      classes = [
        "flex items-center justify-between",
        options[:padding],
        options[:bg_class],
        ("rounded-lg" if options[:rounded]),
        options[:class_name]
      ].compact.join(" ")

      content_tag(options[:tag], class: classes) do
        safe_join([
          content_tag(:span, label, class: options[:label_class]),
          content_tag(:span, class: options[:value_class]) do
            block_given? ? capture(&block) : (value.to_s)
          end
        ])
      end
    end
  end
end