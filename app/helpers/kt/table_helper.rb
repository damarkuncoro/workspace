# class: kt-table kt-table-border table-fixed
# class: kt-table-col
# kt-table-col-label
# kt-table-col-sort
module KT::TableHelper
  # Sertakan helper dinamis kt_* agar tersedia di konteks ini
  include KT::BaseHelper
  # Sertakan helper rating agar pemanggilan build_rating tetap tersedia
  include KT::RatingHelper
  # kt_table: wrapper umum untuk elemen table
  # SRP: Menyediakan pembungkus sederhana tanpa opini.
  def kt_table(*args, &block)
    options = args.extract_options!
    extra_class = options.delete(:class) || options.delete(:class_name)
    options[:class] = ["kt-table", extra_class].compact.join(" ")
    content_tag(:table, *(args << options), &block)
  end

  # kt_table_border: wrapper table dengan border (kelas ditentukan oleh caller)
  def kt_table_border(*args, &block)
    options = args.extract_options!
    extra_class = options.delete(:class) || options.delete(:class_name)
    options[:class] = ["kt-table-border", extra_class].compact.join(" ")
    content_tag(:table, *(args << options), &block)
  end

  # kt_table_fixed: wrapper table dengan layout fixed
  def kt_table_fixed(*args, &block)
    content_tag(:table, *args, &block)
  end

  # kt_table_col: sel kolom (td)
  def kt_table_col(*args, &block)
    tag_name = :span
    tag_name = args.shift if args.first.is_a?(Symbol)
    options = args.extract_options!
    extra_class = options.delete(:class) || options.delete(:class_name)
    options[:class] = ["kt-table-col", extra_class].compact.join(" ")
    content_tag(tag_name, *(args << options), &block)
  end

  # kt_table_col_label: header kolom (th)
  def kt_table_col_label(*args, &block)
    tag_name = :span
    tag_name = args.shift if args.first.is_a?(Symbol)
    options = args.extract_options!
    extra_class = options.delete(:class) || options.delete(:class_name)
    options[:class] = ["kt-table-col-label", extra_class].compact.join(" ")
    content_tag(tag_name, *(args << options), &block)
  end

  # kt_table_col_sort: header kolom dengan area sort
  def kt_table_col_sort(*args, &block)
    tag_name = :span
    tag_name = args.shift if args.first.is_a?(Symbol)
    options = args.extract_options!
    extra_class = options.delete(:class) || options.delete(:class_name)
    options[:class] = ["kt-table-col-sort", extra_class].compact.join(" ")
    content_tag(tag_name, *(args << options), &block)
  end

  # kt_table_teams: menghasilkan markup identik dengan
  # metronic/layouts/partials/page/main/content/tables/_table_teams.erb
  # Parameter:
  # - rows: Array<Hash> [{ name:, href:, description:, rating:, last_modified:, avatars: [] }]
  # - table_id: String (default: "kt_datatable_1")
  # Catatan: DRY/KISS — header dan struktur dibangun di helper,
  #          isi tbody dihasilkan dari data rows.
  def kt_table_teams(rows: [], table_id: "kt_datatable_1")
    kt_table(:table, id: table_id, data: { "kt-datatable-table": true }, class: "kt-table-border table-fixed") do
      safe_join([
        build_teams_thead,
        content_tag(:tbody) { safe_join(rows.map { |row| build_teams_row(row) }) }
      ])
    end
  end

  private

  # build_teams_thead: header identik dengan _table_teams.erb
  def build_teams_thead
    content_tag(:thead) do
      content_tag(:tr) do
        safe_join([
          content_tag(:th, class: "w-[50px]") do
            tag.input(type: "checkbox", class: "kt-checkbox kt-checkbox-sm", data: { "kt-datatable-check": true })
          end,
          content_tag(:th, class: "w-[280px]") do
            kt_table_col do
              safe_join([
                kt_table_col_label { "Team" },
                kt_table_col_sort {}
              ])
            end
          end,
          content_tag(:th, class: "w-[125px]") do
            kt_table_col do
              safe_join([
                kt_table_col_label { "Rating" },
                kt_table_col_sort {}
              ])
            end
          end,
          content_tag(:th, class: "w-[135px]") do
            kt_table_col do
              safe_join([
                kt_table_col_label { "Last Modified" },
                kt_table_col_sort {}
              ])
            end
          end,
          content_tag(:th, class: "w-[125px]") do
            kt_table_col do
              safe_join([
                kt_table_col_label { "Members" },
                kt_table_col_sort {}
              ])
            end
          end
        ])
      end
    end
  end

  # build_teams_row: baris data untuk teams
  # row: { name:, href:, description:, rating:, last_modified:, avatars: [] }
  def build_teams_row(row)
    content_tag(:tr) do
      safe_join([
        content_tag(:td) do
          tag.input(type: "checkbox", class: "kt-checkbox kt-checkbox-sm")
        end,
        content_tag(:td) do
          content_tag(:div) do
            safe_join([
              content_tag(:a, row[:name].to_s, href: (row[:href] || "#"), class: "leading-none font-medium text-sm text-mono hover:text-primary"),
              content_tag(:span, row[:description].to_s, class: "text-2sm text-secondary-foreground font-normal leading-3")
            ])
          end
        end,
        content_tag(:td) do
          build_rating(row[:rating])
        end,
        content_tag(:td) do
          format_last_modified(row[:last_modified])
        end,
        content_tag(:td) do
          build_avatars(row[:avatars])
        end
      ])
    end
  end

  # build_rating: dipindahkan ke KT::RatingHelper
  # rating_label: dipindahkan ke KT::RatingHelper

  # format_last_modified: format tanggal menjadi "DD Mon, YYYY"
  def format_last_modified(date)
    d = case date
        when String then Date.parse(date) rescue nil
        when Time, DateTime then date.to_date
        when Date then date
        else nil
        end
    (d ? d.strftime("%d %b, %Y") : date.to_s)
  end

  # build_avatars: render avatar list
  def build_avatars(avatars)
    urls = Array(avatars).compact
    content_tag(:div, class: "flex") do
      safe_join(urls.map { |src| tag.img(src: src, class: "hover:z-5 relative shrink-0 rounded-full ring-1 ring-background size-[30px]") })
    end
  end

  # Helper dinamis kt_* dipindahkan ke KT::BaseHelper agar modul ini fokus tabel
end