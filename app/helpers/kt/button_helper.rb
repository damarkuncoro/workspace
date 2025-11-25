# frozen_string_literal: true

# KT::ButtonHelper
# Tanggung jawab:
# - Menyediakan helper untuk membuat tombol dengan styling KT (Keenthemes/Metronic)
# - Mendukung berbagai variant tombol (primary, secondary, danger, dll.)
# - Mendukung ikon dan teks
# - Konsisten dengan desain Metronic
#
# Catatan:
# - Semua metode defensif terhadap nilai nil
# - Menggunakan raw() untuk HTML aman
module KT
  module ButtonHelper
    # Membuat tombol KT dengan variant tertentu
    # Param:
    # - text: [String] teks tombol
    # - url: [String|Hash] URL tujuan
    # - variant: [Symbol, nil] variant tombol (:primary, :secondary, :success, :danger, :warning, :info, :light, :dark)
    #   - Bisa nil untuk menghasilkan gaya outline saja ("kt-btn kt-btn-outline")
    # - outline: [Boolean] jika true menambahkan kelas outline ("kt-btn-outline")
    # - icon: [String] kelas ikon (opsional)
    # - options: [Hash] opsi tambahan untuk link_to
    # Return: [String] HTML tombol
    def kt_button(text, url, variant: nil, outline: false, icon: nil, **options)
      classes = ["kt-btn"]
      classes << "kt-btn-#{variant}" if variant.present?
      classes << "kt-btn-outline" if outline
      classes << options.delete(:class) if options[:class]
      classes = classes.compact.join(" ")

      content = if icon.present?
        "<i class='#{icon}'></i> #{text}"
      else
        text
      end

      link_to url, class: classes, **options do
        raw(content)
      end
    end

    # Tombol outline generik (tanpa warna spesifik)
    # Return: [String] HTML tombol dengan kelas "kt-btn kt-btn-outline"
    def kt_outline_button(text, url, icon: nil, **options)
      kt_button(text, url, outline: true, icon: icon, **options)
    end

    # Tombol primary dengan ikon plus (untuk "New" atau "Create")
    # Param:
    # - text: [String] teks tombol
    # - url: [String|Hash] URL tujuan
    # - options: [Hash] opsi tambahan
    # Return: [String] HTML tombol
    def kt_new_button(text, url, **options)
      kt_button(text, url, variant: :primary, icon: 'ki-filled ki-plus', **options)
    end

    # Tombol secondary (untuk cancel atau back)
    # Param:
    # - text: [String] teks tombol
    # - url: [String|Hash] URL tujuan
    # - options: [Hash] opsi tambahan
    # Return: [String] HTML tombol
    def kt_cancel_button(text, url, **options)
      kt_button(text, url, variant: :secondary, **options)
    end

    # Tombol danger (untuk delete atau destructive actions)
    # Param:
    # - text: [String] teks tombol
    # - url: [String|Hash] URL tujuan
    # - icon: [String] kelas ikon (default: ki-filled ki-trash)
    # - options: [Hash] opsi tambahan
    # Return: [String] HTML tombol
    def kt_delete_button(text, url, icon: 'ki-filled ki-trash', **options)
      kt_button(text, url, variant: :danger, icon: icon, **options)
    end

    # Tombol edit dengan ikon pensil
    # Param:
    # - text: [String] teks tombol (default: 'Edit')
    # - url: [String|Hash] URL tujuan
    # - options: [Hash] opsi tambahan
    # Return: [String] HTML tombol
    def kt_edit_button(text = 'Edit', url, **options)
      kt_button(text, url, variant: :warning, icon: 'ki-filled ki-pencil', **options)
    end

    # Tombol view/show dengan ikon mata
    # Param:
    # - text: [String] teks tombol (default: 'View')
    # - url: [String|Hash] URL tujuan
    # - options: [Hash] opsi tambahan
    # Return: [String] HTML tombol
    def kt_view_button(text = 'View', url, **options)
      kt_button(text, url, variant: :info, icon: 'ki-filled ki-eye', **options)
    end

    # Tombol submit untuk form
    # Param:
    # - text: [String] teks tombol
    # - form: [FormBuilder] form builder object
    # - variant: [Symbol] variant tombol (default: :primary)
    # - icon: [String] kelas ikon (opsional)
    # - options: [Hash] opsi tambahan untuk submit
    # Return: [String] HTML tombol submit
    def kt_submit_button(text, form, variant: nil, outline: false, icon: nil, **options)
      classes = ["kt-btn"]
      classes << "kt-btn-#{variant}" if variant.present?
      classes << "kt-btn-outline" if outline
      classes << options.delete(:class) if options[:class]
      classes = classes.compact.join(" ")

      content = if icon.present?
        "<i class='#{icon}'></i> #{text}"
      else
        text
      end

      form.submit raw(content), class: classes, **options
    end

    # Render error messages untuk form
    # Param:
    # - form: [ActiveModel] model dengan errors
    # Return: [String] HTML error messages
    def kt_form_errors(form)
      return '' unless form.errors.any?

      content_tag(:div, class: "bg-red-50 border border-red-200 rounded-md p-4") do
        content_tag(:div, class: "flex") do
          content_tag(:div, class: "flex-shrink-0") do
            content_tag(:svg, class: "h-5 w-5 text-red-400", viewBox: "0 0 20 20", fill: "currentColor") do
              raw('<path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />')
            end
          end +
          content_tag(:div, class: "ml-3") do
            content_tag(:h3, pluralize(form.errors.count, "error"), class: "text-sm font-medium text-red-800") +
            content_tag(:div, class: "mt-2 text-sm text-red-700") do
              content_tag(:ul, role: "list", class: "list-disc pl-5 space-y-1") do
                form.errors.each do |error|
                  concat content_tag(:li, error.full_message)
                end
              end
            end
          end
        end
      end
    end

    # Render section form dengan styling konsisten
    # Param:
    # - title: [String] judul section
    # - options: [Hash] opsi tambahan (class, etc.)
    # - block: konten section
    # Return: [String] HTML section
    def kt_form_section(title = nil, **options, &block)
      classes = "space-y-6"
      classes += " #{options[:class]}" if options[:class]

      content_tag(:div, class: classes) do
        if title.present?
          content_tag(:h3, title, class: "text-lg font-medium text-gray-900 mb-4") +
          capture(&block)
        else
          capture(&block)
        end
      end
    end

    # Render field read-only
    # Param:
    # - label: [String] label field
    # - value: [String] nilai field
    # - options: [Hash] opsi tambahan
    # Return: [String] HTML field read-only
    def kt_readonly_field(label, value, **options)
      content_tag(:div) do
        content_tag(:label, label, class: "block text-sm font-medium text-gray-700") +
        content_tag(:div, class: "mt-1") do
          content_tag(:input, type: "text", value: value, class: "block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm bg-gray-50 text-gray-900 cursor-not-allowed", readonly: true, **options)
        end
      end
    end

    # Render form actions (cancel dan submit buttons)
    # Param:
    # - form: [FormBuilder] form builder
    # - cancel_url: [String|Hash] URL untuk cancel
    # - submit_text: [String] teks submit button
    # - options: [Hash] opsi tambahan
    # Return: [String] HTML form actions
    def kt_form_actions(form, cancel_url, submit_text, **options)
      content_tag(:div, class: "flex justify-end space-x-3 pt-6 border-t border-gray-200") do
        kt_cancel_button('Cancel', cancel_url) +
        kt_submit_button(submit_text, form, **options)
      end
    end
  end
end
