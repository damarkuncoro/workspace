module KT
  module RatingHelper
    # Sertakan helper dinamis kt_* agar tersedia di konteks ini
    include KT::BaseHelper

    # kt_rating: kontainer rating
    # Menambahkan kelas dasar 'kt-rating' dan menerima opsi tambahan.
    def kt_rating(options = {}, &block)
      base_classes = "kt-rating"
      options[:class] = [base_classes, options[:class]].compact.join(" ")
      content_tag(:div, options, &block)
    end

    # kt_rating_label: satu label rating
    # Menghasilkan <div class="kt-rating-label ..."> dengan konten bintang.
    def kt_rating_label(*args, &block)
      options = args.extract_options!
      extra_class = options.delete(:class) || options.delete(:class_name)
      options[:class] = ["kt-rating-label", extra_class].compact.join(" ")
      content_tag(:div, *(args << options), &block)
    end

    # kt_rating_on: ikon bintang aktif
    # Default tag adalah <i> sesuai konvensi ikon.
    def kt_rating_on(*args, &block)
      options = args.extract_options!
      extra_class = options.delete(:class) || options.delete(:class_name)
      options[:class] = ["kt-rating-on", extra_class].compact.join(" ")
      content_tag(:i, *(args << options), &block)
    end

    # kt_rating_off: ikon bintang non-aktif
    # Default tag adalah <i> sesuai konvensi ikon.
    def kt_rating_off(*args, &block)
      options = args.extract_options!
      extra_class = options.delete(:class) || options.delete(:class_name)
      options[:class] = ["kt-rating-off", extra_class].compact.join(" ")
      content_tag(:i, *(args << options), &block)
    end

    # build_rating: bangun komponen rating 0..5 termasuk setengah bintang
    # Struktur output:
    # <div class="kt-rating">
    #   <div class="kt-rating-label ..."> <i class="kt-rating-on ..."></i> <i class="kt-rating-off ..."></i> </div>
    #   ... (5 label total)
    # </div>
    def build_rating(rating)
      r = (rating.to_f * 2).round / 2.0
      full = r.floor
      half = (r - full).positive? ? 1 : 0
      empty = 5 - full - half

      kt_rating do
        safe_join([
          safe_join(Array.new(full) { rating_label(:full) }),
          safe_join(Array.new(half) { rating_label(:half) }),
          safe_join(Array.new(empty) { rating_label(:empty) })
        ])
      end
    end

    # rating_label: buat satu label rating (full/half/empty)
    # Menggunakan ikon on/off dengan kelas utilitas bawaan.
    def rating_label(kind)
      case kind
      when :full
        kt_rating_label(class: "checked") do
          safe_join([
            kt_rating_on("", class: "ki-solid ki-star text-base leading-none"),
            kt_rating_off("", class: "ki-outline ki-star text-base leading-none")
          ])
        end
      when :half
        kt_rating_label(class: "indeterminate") do
          safe_join([
            kt_rating_on("", class: "ki-solid ki-star text-base leading-none", style: "width: 50.0%"),
            kt_rating_off("", class: "ki-outline ki-star text-base leading-none")
          ])
        end
      else
        kt_rating_label do
          safe_join([
            kt_rating_on("", class: "ki-solid ki-star text-base leading-none"),
            kt_rating_off("", class: "ki-outline ki-star text-base leading-none")
          ])
        end
      end
    end
  end
end