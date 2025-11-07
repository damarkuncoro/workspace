module KT
  module BaseHelper
    # method_missing: helper dinamis untuk semua method kt_*
    # - Mengonversi kt_* menjadi kelas CSS 'kt-*'
    # - Memilih tag default dari peta untuk kelas umum, override via argumen simbol pertama
    # - Mendukung konten eksplisit bila tanpa block
    def method_missing(method_name, *args, &block)
      name = method_name.to_s
      if name.start_with?("kt_")
        css_class = name.sub(/^kt_/, "kt-").gsub("_", "-")

        default_tag_map = {
          # Table related
          "kt-table-col" => :span,
          "kt-table-col-label" => :span,
          "kt-table-col-sort" => :span,
          # Rating related
          "kt-rating" => :div,
          "kt-rating-label" => :div,
          "kt-rating-on" => :i,
          "kt-rating-off" => :i,
          # Forms & misc
          "kt-checkbox" => :input,
          "kt-select" => :select,
          # Layout / containers
          "kt-scrollable-x-auto" => :div,
          "kt-datatable-pagination" => :div
        }

        tag_name = default_tag_map[css_class] || :div

        # Override tag lewat argumen pertama Symbol
        tag_name = args.shift if args.first.is_a?(Symbol)

        # Konten eksplisit bila tanpa block
        content_arg = nil
        if !block_given? && args.first && !args.first.is_a?(Hash)
          content_arg = args.shift
        end

        options = args.extract_options!
        extra_class = options.delete(:class) || options.delete(:class_name)
        merged_class = [css_class, extra_class].compact.join(" ")
        options[:class] = merged_class

        return block_given? ? content_tag(tag_name, options, &block) : content_tag(tag_name, content_arg, options)
      end
      super
    end

    # respond_to_missing?: agar `respond_to?` bekerja untuk kt_* dinamis
    def respond_to_missing?(method_name, include_private = false)
      method_name.to_s.start_with?("kt_") || super
    end
  end
end